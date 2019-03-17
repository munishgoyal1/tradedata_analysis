using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Globalization;
using HttpLibrary;
using System.IO;
using System.IO.Compression;
using ICSharpCode.SharpZipLib.Zip;

namespace BhavcopyDownloader
{
    class Program
    {
        static void Main(string[] args)
        {
            //http://www.nseindia.com/content/historical/EQUITIES/2013/FEB/cm06FEB2013bhav.csv.zip
            string baseURL = "http://www.nseindia.com/content/historical/";
            string referer = "http://www.nseindia.com/products/content/equities/equities/archieve_eq.htm";
            string[] PRODUCT = { "EQUITIES" };
            string[] MONTHS = { "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC" };
            var cookies = new System.Net.CookieContainer();
            //DateTime start = DateTime.ParseExact(args[0], "dd-mm-yyyy", CultureInfo.InvariantCulture);
            //DateTime end = DateTime.ParseExact(args[1], "dd-mm-yyyy", CultureInfo.InvariantCulture);

            //int yearSpan = end.Year - start.Year;

            foreach (var prod in PRODUCT)
            {
                string productUrl = baseURL + prod + "/";

                for (int yr = 2010; yr <= 2013; yr++)
                {
                    string yrUrl = productUrl + yr + "/";
                    foreach (string mon in MONTHS)
                    {
                        string monUrl = yrUrl + mon + "/";
                        for (int dt = 4; dt <= 31; dt++)
                        {
                            string fileName = "cm" + (dt <= 9 ? "0" + dt : dt.ToString()) + mon + yr.ToString() + "bhav.csv.zip";
                            string dtUrl = monUrl + fileName;

                            HttpHelper.DownloadZipFile(dtUrl, fileName, referer);


                            //http://www.nseindia.com/content/historical/EQUITIES/2010/JAN/cm05JAN2010bhav.csv.zip
                            //dtUrl = "http://www.geekpedia.com/pics/scrSaver/GeekpediaScr.zip";
                            //referer = null;
                            //fileName = "test.zip";

                            string content = HttpHelper.GetWebPageResponse(dtUrl, null, referer, cookies);

                            if (content != null)
                            {
                                var len = content.Length;
                                var data = Encoding.Unicode.GetBytes(content.ToCharArray()); //GetBytes(content);
                                
                            //using(MemoryStream ms = new MemoryStream(data))
                            //  using(FileStream fs = new FileStream(fileName, FileMode.Create))
                            //using (GZipStream str = new GZipStream(ms, CompressionMode.Decompress))
                            //{
                            //    byte[] arr = new byte[100];
                            //    str.Read(arr, 1, 50);
                            //    //str.CopyTo(fs);
                                
                            //}
                                
                                //    using(FileStream fs = new FileStream("cm04JAN2000bhav.csv.zip", FileMode.Open))
                                //    using (ZipFile zf = new ZipFile(fs))
                                //using(FileStream ofs = new FileStream(zf.GetInputStream(
                                //    {
                                //        zf
                                //    }

                          //      using (ZipFile zip = new ZipFile("cm04JAN2000bhav.csv.zip"))  
                          //{  
                          //  foreach (ZipEntry e in zip)  
                          //  {  
                          //    var arr = e.ExtraData;//TargetDirectory, true);  // overwrite == true  
                          //    File.WriteAllBytes("cm04JAN2000bhav.csv", arr);
                          //  }  
                          //}  

//                                using (var fs = new FileStream(sourcePath, FileMode.Open, FileAccess.Read)
//using (var zf = new ZipFile(fs)) {
//   var ze = zf.GetEntry(fileName);
//   if (ze == null) {
//      throw new ArgumentException(fileName, "not found in Zip");
//   }

//   using (var s = zf.GetInputStream(ze)) {
//      // do something with ZipInputStream
//   }
//}
                                //fileName = "test.zip";
                                //dtUrl = "http://www.geekpedia.com/pics/scrSaver/GeekpediaScr.zip";
                                HttpHelper.DownloadZipFile(dtUrl, fileName);
                                FastZip fz = new FastZip();
                                //fz.ExtractZip(fileName, ".", null);
                                if (data != null)
                                {
                                    File.WriteAllBytes(fileName, data);
                                //    //File.WriteAllText(fileName, content);
                                //    //using(FileStream fs = new FileStream("cm04JAN2000bhav.csv.zip", FileMode.Open))
                                //    //using (FileStream fs = new FileStream("cm04JAN2000bhav.csv.zip", FileMode.Open))
                                //    using (MemoryStream ms = new MemoryStream(data))
                                //    {
                                //        FastZip fz = new FastZip();

                                //        fz.ExtractZip(ms, ".", FastZip.Overwrite.Always, null, null, null, false, false);
                                //        //fz.ExtractZip(fileName, ".", null);
                                //    }
                                //    //File.Delete(fileName);
                                }
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
