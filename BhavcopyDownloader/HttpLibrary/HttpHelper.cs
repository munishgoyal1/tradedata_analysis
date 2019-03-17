using System;
using System.IO;
using System.IO.Compression;
using System.Net;
using System.Text;
using ICSharpCode.SharpZipLib.Zip;

namespace HttpLibrary
{
    public static class HttpHelper
    {
        private static string DecompressGzip(Stream in_InputStream)
        {
            Stream lv_OutputStream = new MemoryStream();
            byte[] lv_Buffer = new byte[4096];
            using (GZipStream lv_gzip = new GZipStream(in_InputStream, CompressionMode.Decompress))
            {
                int i;
                while ((i = lv_gzip.Read(lv_Buffer, 0, lv_Buffer.Length)) != 0)
                {
                    lv_OutputStream.Write(lv_Buffer, 0, i);
                }
            }
            lv_OutputStream.Position = 0;
            using (StreamReader sr = new StreamReader(lv_OutputStream))
            {
                string str = sr.ReadToEnd();
                return str;
            }
        }

        private static string DecompressDeflate(Stream in_InputStream)
        {
            Stream lv_OutputStream = new MemoryStream();
            byte[] lv_Buffer = new byte[4096];
            using (DeflateStream lv_Deflate = new DeflateStream(in_InputStream, CompressionMode.Decompress))
            {
                int i;
                while ((i = lv_Deflate.Read(lv_Buffer, 0, lv_Buffer.Length)) != 0)
                {
                    lv_OutputStream.Write(lv_Buffer, 0, i);
                }
            }
            lv_OutputStream.Position = 0;
            using (StreamReader sr = new StreamReader(lv_OutputStream))
            {
                string str = sr.ReadToEnd();
                return str;
            }
        }

        public static string GetWebPageResponse(string url,
            string postdata,
            string referer,
            CookieContainer cookieContainer)
        {
            return GetWebPageResponse(url,
                postdata,
                referer,
                cookieContainer,
                true);
        }

        public static string GetWebPageResponse(string url,
            string postdata,
            string referer,
            CookieContainer cookieContainer,
            bool allowAutoRedirect)
        {
            if (cookieContainer == null) throw new ArgumentNullException("cookieContainer");
            try
            {
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
                request.Accept = "image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*";
                request.Headers["Accept-Language"] = "en-us";
                request.Headers["Accept-Encoding"] = "gzip, deflate";
                if (!string.IsNullOrEmpty(referer))
                {
                    request.Referer = referer;
                }
                request.AllowAutoRedirect = allowAutoRedirect;
                request.CookieContainer = cookieContainer;
                request.KeepAlive = true;
                request.UserAgent = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; InfoPath.1)";
                if (!string.IsNullOrEmpty(postdata))
                {
                    request.ContentType = "application/x-www-form-urlencoded";
                   
                    request.Method = "POST";
                    byte[] b = ASCIIEncoding.ASCII.GetBytes(postdata);
                    request.ContentLength = b.Length;
                    using (Stream reqStream = request.GetRequestStream())
                    {
                        reqStream.Write(b, 0, b.Length);
                        reqStream.Flush();
                    }
                }
                else
                {
                    //request.ContentType = "application/zip";
                    request.Method = "GET";
                }
                using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
                {
                    using (Stream stream = response.GetResponseStream())
                    {
                        string data = null;
                        if (response.ContentEncoding.IndexOf("gzip") > -1)
                        {
                            data = DecompressGzip(stream);
                        }
                        else if (response.ContentEncoding.IndexOf("deflate") > -1)
                        {
                            data = DecompressDeflate(stream);
                        }
                        else
                        {
                            using (StreamReader sr = new StreamReader(stream))
                            {
                                data = sr.ReadToEnd();
                            }
                        }
                        return data;
                    }
                }
            }
            catch (IOException)
            {
                return null;
            }
            catch (WebException)
            {
                return null;
            }
        }

        public static void DownloadZipFile(string url, string filePath, string referer)
        {
            try
            {
                using (var client = new WebClient())
                {
                    //client.Headers.Add("User-Agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; SV1; .NET CLR 1.1.4322; InfoPath.1)");
                    //client.Headers.Add("Accept", "*/*");
                    //client.Headers.Add(HttpRequestHeader.UserAgent, "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; .NET CLR 1.0.3705;)");
                    client.Headers.Add(HttpRequestHeader.UserAgent, "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.172 Safari/537.22");
                    //client.Credentials = CredentialCache.DefaultCredentials;
                    client.Headers.Add(HttpRequestHeader.Referer, referer);
                    client.Headers.Add(HttpRequestHeader.Accept, "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8");
                    client.Headers.Add(HttpRequestHeader.AcceptEncoding, "gzip,deflate,sdch");
                    client.Headers.Add(HttpRequestHeader.AcceptCharset, "ISO-8859-1,utf-8;q=0.7,*;q=0.3");
                    client.Headers.Add(HttpRequestHeader.Cookie, "NSE-TEST-1=1809850378.20480.0000; JSESSIONID=255E05749AE7B507B535FF78B4D03E97");
                    client.Headers.Add(HttpRequestHeader.AcceptLanguage, "en-US,en;q=0.8");
                    
                    client.DownloadFile(url, filePath);
                }
            }
            catch(Exception ex)
            { 
            
            }
        }
    }
}
