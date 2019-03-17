using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Globalization;
using HttpLibrary;
using System.IO;
using System.IO.Compression;
using ICSharpCode.SharpZipLib.Zip;
using System.Diagnostics;

namespace BhavcopyDownloader
{
    partial class Program
    {
        static void Main(string[] args)
        {
            var src = args.Length > 0 ? int.Parse(args[0]) : 1; // 0 == nseindia, 1 == yahoo
            var dir = args.Length > 1 ? args[1] : Directory.GetCurrentDirectory(); // download directory
            var days = args.Length > 2 ? int.Parse(args[2]) : 1; // number of past days from today to get data for
            var symFile = @"D:\TradingSlate\YahooFinanceStockCodes.csv";
            var type = 0;
            if (src == 0)
                type = args.Length > 3 ? int.Parse(args[3]) : 0; // 0 == equities, 1 == derivatives, 2 == both
            else
                symFile = args.Length > 3 ? args[3] : symFile; // yahoo symbols file

            if (src == 0)
                DownloadBhavcopies(type, days, dir);
            else
                DownloadYahooHistorical(symFile, days, dir);

            
            var cleanup = args.Length > 4 ? int.Parse(args[4]) : 0; // 0 == no, 1 == yes

            if(src == 0 && cleanup == 1)
            {
                var files = Directory.EnumerateFiles(dir, "*.csv", SearchOption.AllDirectories);
                foreach (var file in files)
                {
                    var lines = File.ReadAllLines(file);
                    var trimmedLines = lines.Select(l => l.TrimEnd(','));
                    File.WriteAllLines(file, trimmedLines);
                }

                foreach (var file in files)
                {
                    FileInfo fi = new FileInfo(file);
                    var date = DateTime.Parse(fi.Name.Substring(2, 9));
                    if (date.Date < new DateTime(2011, 06, 22).Date)
                    {
                        var lines = File.ReadAllLines(file);
                        var extraEmptyFieldsLines = lines.Select(l => l + ",,");
                        File.WriteAllLines(file, extraEmptyFieldsLines);
                    }
                }
            }
        }

        static void DownloadBhavcopies(int type, int days, string dir)
        {
            //http://www.nseindia.com/content/historical/EQUITIES/2013/FEB/cm06FEB2013bhav.csv.zip
            //http://www.nseindia.com/content/historical/DERIVATIVES/2013/APR/fo01APR2013bhav.csv.zip

            string baseURL = "http://www.nseindia.com/content/historical/";
            const string REFERER_EQT = "http://www.nseindia.com/products/content/equities/equities/archieve_eq.htm";
            const string REFERER_FNO = "http://www.nseindia.com/products/content/derivatives/equities/historical_fo.htm";

            List<string> PRODUCT = new List<string>(3);
            string DOWNLOAD_DIR = dir;

            if (type == 0 || type == 2)
                PRODUCT.Add("EQUITIES");

            if (type == 1 || type == 2)
                PRODUCT.Add("DERIVATIVES");

            foreach (var prod in PRODUCT)
            {
                string productUrl = baseURL + prod + "/";
                string downloadDir = Path.Combine(DOWNLOAD_DIR, prod);
                if (!Directory.Exists(downloadDir))
                    Directory.CreateDirectory(downloadDir);

                var st = DateTime.Today.AddDays(-days);
                var end = DateTime.Today;

                var referer = REFERER_FNO;
                var filePrefix = "fo";

                if (prod == "EQUITIES")
                {
                    filePrefix = "cm";
                    referer = REFERER_EQT;
                }

                for (DateTime dt = st; dt.Date <= end.Date; dt = dt.AddDays(1))
                {
                    int yr = dt.Year;
                    string yrUrl = productUrl + yr + "/";

                    string mon = dt.ToString("MMM").ToUpper();
                    string monUrl = yrUrl + mon + "/";
                    int day = dt.Day;

                    string fileName = filePrefix + (day <= 9 ? "0" + day : day.ToString()) + mon + yr.ToString() + "bhav.csv.zip";
                    string dtUrl = monUrl + fileName;

                    var filePath = Path.Combine(downloadDir, fileName);

                    if(File.Exists(filePath.Replace(".zip","")))
                        continue;

                    HttpHelper.DownloadZipFile(dtUrl, filePath, referer);

                    if (File.Exists(filePath))
                    {
                        FastZip fz = new FastZip();
                        fz.ExtractZip(filePath, downloadDir, null);
                        File.Delete(filePath);
                    }
                }
            }
        }
    }
}
