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
        static void DownloadHistoricalFnO()
        {
            //http://www.nseindia.com/content/historical/EQUITIES/2013/FEB/cm06FEB2013bhav.csv.zip
            string baseURL = "http://www.nseindia.com/content/historical/";
            string referer = "http://www.nseindia.com/products/content/derivatives/equities/historical_fo.htm";
            string[] PRODUCT = { "DERIVATIVES" };
            string[] MONTHS = { "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC" };
            string DOWNLOAD_DIR = @"c:\Bhavcopies";
            //GET /content/fo/contractvol/datafiles/FUTIDX_NIFTY_01-Jun-2000_TO_29-Jun-2000.csv HTTP/1.1
            //GET /products/dynaContent/common/productsSymbolMapping.jsp?instrumentType=FUTIDX&symbol=NIFTY&expiryDate=29-06-2000&optionType=select&strikePrice=&dateRange=&fromDate=01-Jun-2000&toDate=29-Jun-2000&segmentLink=9&symbolCount= HTTP/1.1

            //http://www.nseindia.com/products/dynaContent/common/productsSymbolMapping.jsp?instrumentType=FUTIDX&symbol=NIFTY&expiryDate=29-06-2000&optionType=select&strikePrice=&dateRange=&fromDate=01-Jun-2000&toDate=29-Jun-2000&segmentLink=9&symbolCount=
            //http://www.nseindia.com/content/fo/contractvol/datafiles/FUTIDX_NIFTY_01-Jun-2000_TO_29-Jun-2000.csv

            // Straight Fwd EOD Bhavcopy
            //http://www.nseindia.com/content/historical/DERIVATIVES/2013/APR/fo01APR2013bhav.csv.zip

            foreach (var prod in PRODUCT)
            {
                string productUrl = baseURL + prod + "/";

                for (int yr = 2000; yr <= 2013; yr++)
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
                            string fileName = "fo" + (dt <= 9 ? "0" + dt : dt.ToString()) + mon + yr.ToString() + "bhav.csv.zip";
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
    }
}
