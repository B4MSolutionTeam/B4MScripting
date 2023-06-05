using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Oracle.ManagedDataAccess.Client;
using System.Configuration;
using System.Data;

namespace VersiondogReportService
{
    class Database
    {
        static OracleConnection Conn;
        static OracleCommand Cmd;

        //Define Oracle Connection
        public static void DatabaseConnection()
        {
            string connString = BuildConnectionString(Properties.Settings.Default.Datenbank_User, Properties.Settings.Default.Datenbank_Passwort);
            if (null != connString)
            {
                Conn = new OracleConnection { ConnectionString = connString };
            }
        }

        //Connection String Builder for Oracle Connection
        private static String BuildConnectionString(string username, string passwort)
        {
            ConnectionStringSettings settings = ConfigurationManager.ConnectionStrings["OracleConnection"];
            string connstring = null;

            if (null != settings)
            {
                string connectionString = settings.ConnectionString;
                OracleConnectionStringBuilder builder = new OracleConnectionStringBuilder(connectionString)
                {
                    UserID = username,
                    Password = passwort
                };
                connstring = builder.ConnectionString;

            }

            return connstring;
        }

        //Mehtode for Sending Data To Oracle DB || Currently not in Use
        public static void Sqlwrite(string sqlCommand)
        {
            try
            {
                Conn.Open();
                Cmd = Conn.CreateCommand();
                Cmd.CommandText = sqlCommand;
                Cmd.ExecuteNonQuery();
                Conn.Close();
            }
            catch (Exception ex)
            {
                Log.Error(ex);
            }
            finally
            {
                ConnectionClose();
            }
        }

        //Bulk Inserting of Merged Data to Oracle DB
        public static void SqlBulkInsert(DataTable dt)
        {
            try
            {
                Conn.Open();

                using (OracleBulkCopy bulkCopy = new OracleBulkCopy(Conn, OracleBulkCopyOptions.Default))
                {
                    foreach (DataColumn column in dt.Columns)
                    {
                        bulkCopy.ColumnMappings.Add(column.ColumnName, column.ColumnName);
                    }

                    bulkCopy.DestinationTableName = $"T_TEMPTABLE";
                    bulkCopy.WriteToServer(dt);
                    bulkCopy.Close();

                    Cmd = Conn.CreateCommand();
                    Cmd.CommandText = $"MERGE INTO {Properties.Settings.Default.Datenbank_Tabelle} DEST " +
                                       "USING (SELECT PLANT, " +
                                                     "VALUESTREAM, " +
                                                     "COMPONENTID, " +
                                                     "COMPONENTTYPEID, " +
                                                     "COMPONENT, " +
                                                     "COMPONENTTYPE, " +
                                                     "LASTIMPORTINDB, " +
                                                     "RESULTVERSIONVSBACKUP, " +
                                                     "RESULTBACKUPVSPREBACKUP, " +
                                                     "LASTCHECK, " +
                                                     "COMPONENTTREE, " +
                                                     "EXECUTION, " +
                                                     "VERSIONNUMBER, " +
                                                     "VERSION, " +
                                                     "SUBSECTION, " +
                                                     "STATION, " +
                                                     "SECTION, " +
                                                     "LASTCHANGE, " +
                                                     "VERSIONCOMPARE, " +
                                                     "IP_NAME, " +
                                                     "UPLOADAGENT, " +
                                                     "NEXTSTART, " +
                                                     "JOBSTART, " +
                                                     "JOBFINISH, " +
                                                     "TIMESTAMPBACKUP, " +
                                                     "TIMESTAMPPREBACKUP, " +
                                                     "DEACTIVATEDCOMMENT, " +
                                                     "JOBID, " +
                                                     "JOBNAME " +
                                       "FROM T_TEMPTABLE) SRC " +
                                       "ON (DEST.COMPONENTID = SRC.COMPONENTID " +
                                           "AND DEST.JOBID = SRC.JOBID) " +
                                       "WHEN MATCHED THEN UPDATE SET " +
                                       "DEST.PLANT = SRC.PLANT, " +
                                       "DEST.VALUESTREAM = SRC.VALUESTREAM, " +
                                       "DEST.COMPONENTTYPEID = SRC.COMPONENTTYPEID, " +
                                       "DEST.COMPONENT = SRC.COMPONENT, " +
                                       "DEST.COMPONENTTYPE = SRC.COMPONENTTYPE, " +
                                       "DEST.LASTIMPORTINDB = SRC.LASTIMPORTINDB, " +
                                       "DEST.RESULTVERSIONVSBACKUP = SRC.RESULTVERSIONVSBACKUP, " +
                                       "DEST.RESULTBACKUPVSPREBACKUP = SRC.RESULTBACKUPVSPREBACKUP, " +
                                       "DEST.LASTCHECK = SRC.LASTCHECK, " +
                                       "DEST.COMPONENTTREE = SRC.COMPONENTTREE, " +
                                       "DEST.EXECUTION = SRC.EXECUTION, " +
                                       "DEST.VERSIONNUMBER = SRC.VERSIONNUMBER, " +
                                       "DEST.VERSION = SRC.VERSION, " +
                                       "DEST.SUBSECTION = SRC.SUBSECTION, " +
                                       "DEST.STATION = SRC.STATION, " +
                                       "DEST.SECTION = SRC.SECTION, " +
                                       "DEST.LASTCHANGE = SRC.LASTCHANGE, " +
                                       "DEST.VERSIONCOMPARE = SRC.VERSIONCOMPARE, " +
                                       "DEST.IP_NAME = SRC.IP_NAME, " +
                                       "DEST.UPLOADAGENT = SRC.UPLOADAGENT, " +
                                       "DEST.NEXTSTART = SRC.NEXTSTART, " +
                                       "DEST.JOBSTART = SRC.JOBSTART, " +
                                       "DEST.JOBFINISH = SRC.JOBFINISH, " +
                                       "DEST.TIMESTAMPBACKUP = SRC.TIMESTAMPBACKUP, " +
                                       "DEST.TIMESTAMPPREBACKUP = SRC.TIMESTAMPPREBACKUP, " +
                                       "DEST.DEACTIVATEDCOMMENT = SRC.DEACTIVATEDCOMMENT, " +
                                       "DEST.JOBNAME = SRC.JOBNAME " +
                                       "WHEN NOT MATCHED THEN " +
                                       "INSERT (" +
                                       "PLANT," +
                                       "VALUESTREAM," +
                                       "COMPONENTID," +
                                       "COMPONENTTYPEID," +
                                       "COMPONENT," +
                                       "COMPONENTTYPE," +
                                       "LASTIMPORTINDB," +
                                       "RESULTVERSIONVSBACKUP," +
                                       "RESULTBACKUPVSPREBACKUP," +
                                       "LASTCHECK," +
                                       "COMPONENTTREE," +
                                       "EXECUTION," +
                                       "VERSIONNUMBER," +
                                       "VERSION," +
                                       "SUBSECTION," +
                                       "STATION," +
                                       "SECTION," +
                                       "LASTCHANGE," +
                                       "VERSIONCOMPARE," +
                                       "IP_NAME," +
                                       "UPLOADAGENT," +
                                       "NEXTSTART," +
                                       "JOBSTART," +
                                       "JOBFINISH," +
                                       "TIMESTAMPBACKUP," +
                                       "TIMESTAMPPREBACKUP," +
                                       "DEACTIVATEDCOMMENT," +
                                       "JOBID," +
                                       "JOBNAME) " +
                                       "VALUES (SRC.PLANT,SRC.VALUESTREAM,SRC.COMPONENTID,SRC.COMPONENTTYPEID,SRC.COMPONENT,SRC.COMPONENTTYPE,SRC.LASTIMPORTINDB,SRC.RESULTVERSIONVSBACKUP,SRC.RESULTBACKUPVSPREBACKUP,SRC.LASTCHECK,SRC.COMPONENTTREE,SRC.EXECUTION,SRC.VERSIONNUMBER,SRC.VERSION,SRC.SUBSECTION,SRC.STATION,SRC.SECTION,SRC.LASTCHANGE,SRC.VERSIONCOMPARE,SRC.IP_NAME,SRC.UPLOADAGENT,SRC.NEXTSTART,SRC.JOBSTART,SRC.JOBFINISH,SRC.TIMESTAMPBACKUP,SRC.TIMESTAMPPREBACKUP,SRC.DEACTIVATEDCOMMENT,SRC.JOBID,SRC.JOBNAME)";
                    Cmd.ExecuteNonQuery();
                }

                Conn.Close();
            }
            catch (Exception ex)
            {
                Log.Error(ex);
            }
            finally
            {
                ConnectionClose();
            }
        }

        //Bulk Inserting of Component Assignemts
        public static void SqlBulkInsertAssignment(DataTable dt)
        {
            try
            {
                Conn.Open();

                using (OracleBulkCopy bulkCopy = new OracleBulkCopy(Conn, OracleBulkCopyOptions.Default))
                {
                    foreach (DataColumn column in dt.Columns)
                    {
                        bulkCopy.ColumnMappings.Add(column.ColumnName, column.ColumnName);
                    }

                    bulkCopy.DestinationTableName = $"T_TEMPTABLE_ZUWEISUNG";
                    bulkCopy.WriteToServer(dt);
                    bulkCopy.Close();

                    Cmd = Conn.CreateCommand();
                    Cmd.CommandText = $"MERGE INTO {Properties.Settings.Default.Datenbank_Tabelle_Zuweisung} DEST " +
                                      $"USING (SELECT * FROM T_TEMPTABLE_ZUWEISUNG) SRC " +
                                       "ON (SRC.COMPONENTTYPEID = DEST.COMPONENTTYPEID) " +
                                       "WHEN MATCHED THEN UPDATE SET " +
                                       "DEST.COMPONENTTYPE_NAME_COMPLETE = SRC.COMPONENTTYPE_NAME_COMPL " +
                                       "WHEN NOT MATCHED THEN " +
                                       "INSERT (COMPONENTTYPEID,COMPONENTTYPE_NAME_COMPLETE) " +
                                       "VALUES (SRC.COMPONENTTYPEID,SRC.COMPONENTTYPE_NAME_COMPL)";
                    Cmd.ExecuteNonQuery();
                }

                Conn.Close();
                Console.WriteLine("DB Eintrag");
            }
            catch (Exception ex)
            {
                Log.Error(ex);
            }
            finally
            {
                ConnectionClose();
            }
        }

        //Check for Open Connection and Close if any ist Open
        public static void ConnectionClose()
        {
            if (Conn != null)
            {
                Conn.Close();
            }
        }

        

    }
}
