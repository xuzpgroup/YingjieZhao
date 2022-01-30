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
            ///<summary>
            ///There are multiple ITEMs in each dump file, and each ITEM has multiple ATOMS written in the fourth line, the purpose is to read the atomic XU, YU, ZU data
            ///First read the number of ATOMS in each ITEM in the dump file, and then read the atomic coordinate data in the ITEM and write it into the txt file
            ///</summary>
            ///
            for (int n = 1; n < 481; n++)
            {
                int m = n+480;
                StreamReader srReadFile = new StreamReader("E:\\Machine learning conformation recognition\\DUMP\\cylinder\\" + n.ToString() + ".dump");//read
                FileStream fs = new FileStream("E:\\Machine learning conformation recognition\\TXT\\cylinder\\" + "cylinder_" + n.ToString() + ".txt", FileMode.Create);//save

                StreamWriter swWriteFile = new StreamWriter(fs);
                string line;
                //swWriteFile.WriteLine("XU YU ZU");
                int num = 0;
                while (!srReadFile.EndOfStream)
                {
                    line = srReadFile.ReadLine();
                    if (line.Contains("ITEM: NUMBER OF ATOMS"))
                    {
                        num = int.Parse(srReadFile.ReadLine());//Read a line down to get the number                  
                    }
                    if (line.Contains("id xu yu zu c_k c_p c_bo c_di"))
                    {
                        for (int i = 0; i < num; i++)
                        {
                            line = srReadFile.ReadLine();
                            string[] data = line.Split(' ');
                            string nu = data[0];
                            string xu = data[1];
                            string yu = data[2];
                            string zu = data[3];
                            swWriteFile.WriteLine(xu + "," + yu + "," + zu);

                        }
                        break;//Read only one item
                    }
                }
                swWriteFile.Flush();
                swWriteFile.Close();
                fs.Close();
                srReadFile.Close();
            }
        }
        

    }
}
