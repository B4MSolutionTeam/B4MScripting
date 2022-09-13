

using (System.Xml.XmlReader reader = System.Xml.XmlReader.Create(@"C:\New folder\Ba_FCEV_Jobs.csv"))
{
    while (reader.Read())
    {
        if(reader.IsStartElement())
        {
            System.Console.WriteLine(reader.Name.ToString());
        }
    }
}


