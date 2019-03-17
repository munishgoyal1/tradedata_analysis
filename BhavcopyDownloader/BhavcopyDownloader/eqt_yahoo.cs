using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using HttpLibrary;
using ICSharpCode.SharpZipLib.Zip;
using System.Net;

namespace BhavcopyDownloader
{
    partial class Program
    {
        static void DownloadYahooHistorical(string symFile, int days, string dir)
        {
            // downloadUrl = http://ichart.finance.yahoo.com/table.csv?s=RELIANCE.NS&d=3&e=27&f=2013&g=d&a=7&b=12&c=2002&ignore=.csv
            // referer = "http://finance.yahoo.com/q/hp?s=TCS.NS"
            const string REFERER_EQT = "http://finance.yahoo.com/q/hp?s={0}+Historical+Prices";
            string BASE_URL = "http://ichart.finance.yahoo.com/table.csv?s={0}&d={1}&e={2}&f={3}&g=d&a={4}&b={5}&c={6}&ignore=.csv";

            // days == -1 means get all
            DateTime st = new DateTime(1990, 1, 1);
            DateTime end = DateTime.Today;

            string downloadDir = Path.Combine(dir, "YahooEOD");
            if (!Directory.Exists(downloadDir))
                Directory.CreateDirectory(downloadDir);

            var symLines = File.ReadAllLines(symFile);
            var cookies = new CookieContainer();
            foreach (var symLine in symLines)
            {
                var parts = symLine.Split(new[] { ',' });
                var ysym = parts[1];
                var nsym = parts[0];

                if (days != -1)
                    st = DateTime.Today.AddDays(-days);

                string symUrl = string.Format(BASE_URL, ysym, end.Month, end.Day, end.Year, st.Month, st.Day, st.Year);
                var referer = string.Format(REFERER_EQT, ysym);
                string fileName = nsym + ".csv";
                var filePath = Path.Combine(downloadDir, fileName);

                var data = HttpHelper.GetWebPageResponse(symUrl, null, referer, cookies);
                //var dataLines = data.
                File.WriteAllText(filePath, data, Encoding.Unicode);
                //HttpHelper.DownloadZipFile(symUrl, filePath, referer);

                //if (File.Exists(filePath))
                //{
                //    FastZip fz = new FastZip();
                //    fz.ExtractZip(filePath, downloadDir, null);
                //    File.Delete(filePath);
                //}
            }
        }
    }
}
