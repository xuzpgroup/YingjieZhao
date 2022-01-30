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
            //for (int n = 176; n < 177; n++)
            for (int n = 1; n < 961; n++)
            {
                //int x = 1;

                //sphere
                string readpath = "D:\\ML-generate\\XYZ_pre\\sphere\\" + n.ToString() + ".xyz";
                string savepath = "D:\\ML-generate\\XYZ-new\\sphere\\" + n.ToString() + ".xyz";

                StreamReader srReadFile = new StreamReader(readpath);//读取文件
                FileStream fs = new FileStream(savepath, FileMode.Create);//保存文件位置

                StreamWriter swWriteFile = new StreamWriter(fs);
                string line; 
                //swWriteFile.WriteLine("XU YU ZU");
                int num_line = 0;int last11600 = 0; int minimize = 0;
                while (!srReadFile.EndOfStream)
                {
                    line = srReadFile.ReadLine();
                    //Console.WriteLine(line);
                    //while (line != null)
                    {
                        num_line++;
                        //Console.WriteLine(num_line);
                    }
                    if (line.Contains("Atoms. Timestep:"))
                    {
                        last11600 = num_line - 11603;//更新需要的行数
                        minimize = num_line - 2;
                        //Console.WriteLine("11600在" + last11600 + "行");
                    }
                }
                Console.WriteLine("11600在" + last11600 + "行");
                swWriteFile.Flush();
                swWriteFile.Close();
                fs.Close();
                srReadFile.Close();

                StreamReader srReadFile2 = new StreamReader(readpath);//读取文件
                FileStream fs2 = new FileStream(savepath, FileMode.Create);//保存文件位置

                StreamWriter swWriteFile2 = new StreamWriter(fs2);
                string line2;
                int num_line2 = 0;
                //last11600 = 754131;
                while (!srReadFile2.EndOfStream)
                {
                    line2 = srReadFile2.ReadLine();
                    //Console.WriteLine(line);
                    //while (line != null)
                    {
                        num_line2++;
                        //Console.WriteLine(num_line);
                    }
                    if (num_line2 >=last11600 && num_line2 <= minimize)
                    {
                        swWriteFile2.WriteLine(line2);
                    }
                }
                //Console.WriteLine("11600在" + last11600 + "行");
                swWriteFile2.Flush();
                swWriteFile2.Close();
                fs.Close();
                srReadFile2.Close();
                Console.WriteLine(n);
            }

        }
        

    }
}
