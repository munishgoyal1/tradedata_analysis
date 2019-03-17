using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using HttpLibrary;
using ICSharpCode.SharpZipLib.Zip;

namespace BhavcopyDownloader
{
    partial class Program
    {
        static void DownloadHistoricalEqt()
        {
            //http://www.nseindia.com/content/historical/EQUITIES/2013/FEB/cm06FEB2013bhav.csv.zip
            string baseURL = "http://www.nseindia.com/content/historical/";
            string referer = "http://www.nseindia.com/products/content/equities/equities/archieve_eq.htm";
            string[] PRODUCT = { "EQUITIES" };
            string[] MONTHS = { "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC" };
            string DOWNLOAD_DIR = @"c:\Bhavcopies";
            //var cookies = new System.Net.CookieContainer();
            //DateTime start = DateTime.ParseExact(args[0], "dd-mm-yyyy", CultureInfo.InvariantCulture);
            //DateTime end = DateTime.ParseExact(args[1], "dd-mm-yyyy", CultureInfo.InvariantCulture);

            //int yearSpan = end.Year - start.Year;

            foreach (var prod in PRODUCT)
            {
                string productUrl = baseURL + prod + "/";

                for (int yr = 1995; yr <= 2013; yr++)
                {
                    string downloadYrDir = Path.Combine(DOWNLOAD_DIR, yr.ToString());
                    if (!Directory.Exists(downloadYrDir))
                        Directory.CreateDirectory(downloadYrDir);
                    string yrUrl = productUrl + yr + "/";
                    foreach (string mon in MONTHS)
                    {
                        if (yr == 2013 && mon == "APR") return;
                        string monUrl = yrUrl + mon + "/";
                        for (int dt = 1; dt <= 31; dt++)
                        {
                            string fileName = "cm" + (dt <= 9 ? "0" + dt : dt.ToString()) + mon + yr.ToString() + "bhav.csv.zip";
                            string dtUrl = monUrl + fileName;

                            var filePath = Path.Combine(downloadYrDir, fileName);

                            HttpHelper.DownloadZipFile(dtUrl, filePath, referer);

                            if (File.Exists(filePath))
                            {
                                FastZip fz = new FastZip();
                                fz.ExtractZip(filePath, downloadYrDir, null);
                                File.Delete(filePath);
                            }
                        }
                    }
                }
            }
        }


        static byte[] GetBytes(string str)
        {
            byte[] bytes = new byte[str.Length * sizeof(char)];
            System.Buffer.BlockCopy(str.ToCharArray(), 0, bytes, 0, bytes.Length);
            return bytes;
        }

        static string GetString(byte[] bytes)
        {
            char[] chars = new char[bytes.Length / sizeof(char)];
            System.Buffer.BlockCopy(bytes, 0, chars, 0, bytes.Length);
            return new string(chars);
        }
    }
}
