using System;
using System.Text;
using System.IO;
using System.Collections.Generic;
using System.Linq;


namespace Generatingfiles
{
    class Program
    {
        static void Main(string[] args)
        {
            List<string> stringT = new List<string>( new string[] {"300.0","500.0","700.0","900.0", "1100.0" }) ;
            List<string> stringV = new List<string>(new string[] { "500000", "1000000", "1500000", "2000000" });
            List<string> stringK1 = new List<string>(new string[] { "1.0", "2.0", "4.0", "6.0", "8.0", "10.0", "15.0", "20.0", "30.0", "40.0", "45.0", "60.0" });
            List<string> stringR12 = new List<string>(new string[] { "0.5", "0.55", "0.6", "0.65","0.7" });

            for (int w = 0; w < stringT.Count; w++) 
            {
                for (int a = 0; a < stringV.Count; a++)
                {
                    for (int b = 0; b < stringK1.Count; b++) 
                    {
                        for (int h = 0; h < stringR12.Count; h++) 
                        {
                            StreamReader srReadFile = new StreamReader("E:\\Machine learning conformation recognition\\AutoSample\\in_sphere\\in");//读取文件

                            string os = "E:\\Machine learning conformation recognition\\AutoSample\\sphere\\";//不需要在桌面创建sphere文件夹
                            string aimPath = os + "T" + stringT[w] + "\\" + "V" + stringV[a] + "\\" + "K" + stringK1[b] + "\\" + "R" + stringR12[h] ;
                            Directory.CreateDirectory(aimPath);

                            FileStream fs = new FileStream(aimPath+"\\"+ "in.sphere", FileMode.Create);
                            StreamWriter swWriteFile = new StreamWriter(fs);
                            int row = 1;
                            while (!srReadFile.EndOfStream)
                            {
                                string rline = srReadFile.ReadLine();

                                string wline;
                                if(row == 4)
                                {
                                    wline = "variable Tmax equal   " + stringT[w];
                                }
                                else if( row == 22)
                                {
                                    wline = "variable k1 equal   " + stringK1[b] + "   #";
                                }
                                else if( row == 164)
                                {
                                    wline = "variable r1    equal ${r2}*" + stringR12[h];
                                }
                                else if(row == 170)
                                {
                                    wline = "run     " + stringV[a];
                                }
                                else
                                {
                                    wline = rline;
                                }
                                swWriteFile.WriteLine(wline);
                                row++;
                            }
                            swWriteFile.Flush();
                            swWriteFile.Close();
                            fs.Close();
                            srReadFile.Close();

                            string folder = "E:\\Machine learning conformation recognition\\AutoSample\\origin";
                            var files = Directory.GetFiles(folder, "*", searchOption: SearchOption.AllDirectories);
                            foreach(var file in files)
                            {
                                File.Copy(file, aimPath+"\\" + System.IO.Path.GetFileName(file), true);
                            }
                        }
                    }
                }
            }
        }
    }
}
