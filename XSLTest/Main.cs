using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Xml;
using XSLTest.XSLT;
using XSLTest.Query;

namespace XSLTest
{
    public partial class Main : Form
    {
        private Transformer transformer;
        private QueryManager queryManager;
        public Main()
        {
            InitializeComponent();
            queryManager = new QueryManager();
            queryManager.OnQueryChange += QueryManager_OnQueryChange;
            dataGridView1.AutoGenerateColumns = true;
            openFileDialog1.Filter = "XSLT Translation Files (*.xslt;*.xsl)|*.xslt;*.xsl|All files (*.*)|*.*";
            openFileDialog1.FileName = "";
            openFileDialog2.Filter = "XML Files (*.xml)|*.xml|All files (*.*)|*.*";
            openFileDialog2.FileName = "";
        }

        private void QueryManager_OnQueryChange(object sender, QueryChangedEventArgs e)
        {
            bindingSource1.DataSource = e.Table;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            DialogResult res = this.openFileDialog1.ShowDialog();
            if(res == DialogResult.OK)
            {
                comboBox1.Text = openFileDialog1.FileName;
                UpdateXSLTSelection();
            }
        }
        private void UpdateXSLTSelection()
        {
            try
            {
                button1.Text = "Loading...";
                button1.Enabled = false;
                comboBox1.Enabled = false;
                transformer = new Transformer();
                queryManager.ChangeQuery(comboBox1.Text);
                transformer.AddArguments(queryManager.CurrentTable);
                bwTransformOpener.RunWorkerAsync(comboBox1.Text);
                if(!comboBox1.Items.Contains(comboBox1.Text))
                {
                    comboBox1.Items.Add(comboBox1.Text);
                }
                SaveDirectorySetting("xslt", comboBox1.Text);
            }
            catch (InvalidOperationException er)
            {
                //silently ignore, since it will do the work anyway?
            }
            catch (Exception er)
            {
                button1.Enabled = true;
                button1.Text = "Browse";
                comboBox1.Enabled = true;
                richTextBox2.Text = er.ToString();
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            DialogResult res = this.openFileDialog2.ShowDialog();
            if (res == DialogResult.OK)
            {
                comboBox2.Text = openFileDialog2.FileName;
                UpdateInputSelection();
            }
        }

        private void UpdateInputSelection()
        {
            try
            {
                comboBox2.Enabled = false;
                richTextBox1.Text = "";
                worker.RunWorkerAsync(comboBox2.Text);

            }
            catch (InvalidOperationException er)
            {
                //silently ignore, since it will do the work anyway?
            }
            catch (Exception er)
            {
                richTextBox1.Text = er.ToString();
                comboBox2.Enabled = true;
            }
        }

        private void worker_DoWork(object sender, DoWorkEventArgs e)
        {
            BackgroundWorker worker = sender as BackgroundWorker;
            try
            {
                XmlTextReader r = new XmlTextReader(e.Argument as string);
                while (r.Read())
                {
                    MethodInvoker d = delegate ()
                    {
                        richTextBox1.Text += r.ReadOuterXml();
                    };
                    if (InvokeRequired)
                    {
                        Invoke(d);
                    }
                    else
                    {
                        d();
                    }
                }
                e.Result = true;
            }catch(Exception er)
            {
                MethodInvoker d = delegate ()
                {
                    richTextBox1.Text = er.ToString();
                };
                if (InvokeRequired)
                {
                    Invoke(d);
                } else
                {
                    d();
                }
                e.Result = false;
            }
        }

        private void worker_ProgressChanged(object sender, ProgressChangedEventArgs e)
        {
            BackgroundWorker worker = sender as BackgroundWorker;
        }

        private void worker_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            BackgroundWorker worker = sender as BackgroundWorker;
            bool result = (bool) e.Result;
            if (result)
            {
                if (!comboBox2.Items.Contains(comboBox2.Text))
                {
                    comboBox2.Items.Add(comboBox2.Text);
                }
                SaveDirectorySetting("inputFiles", comboBox2.Text);
            }
            comboBox2.Enabled = true;
        }

        private void button3_Click(object sender, EventArgs e)
        {
            try
            {
                richTextBox2.Text = "";
                transformer.AddArguments(queryManager.CurrentTable);
                bwTransform.RunWorkerAsync(richTextBox1.Text);
                CheckCanTransform(true);
            }
            catch (InvalidOperationException er)
            {
                //silently ignore, since it will do the work anyway?
            }
            catch (Exception er)
            {
                richTextBox2.Text = er.ToString();
                CheckCanTransform(true);
            }
        }

        private void richTextBox1_TextChanged(object sender, EventArgs e)
        {
            CheckCanTransform();
        }
        private void CheckCanTransform() { CheckCanTransform(false);  }
        private void CheckCanTransform(bool isMainEvent)
        {
            button3.Enabled = richTextBox1.Text.Length > 10 && transformer != null && transformer.IsLoaded() && !bwTransform.IsBusy;
            if(isMainEvent)
            {
                button3.Text = button3.Enabled ? "Start Transform" : "Transforming ...";
            }
        }

        private void Main_Load(object sender, EventArgs e)
        {
            if (InputSettings.Default.xsltFiles != null)
            {
                foreach (string it in InputSettings.Default.xsltFiles)
                {
                    comboBox1.Items.Add(it);
                }
            }
            if (InputSettings.Default.inputFiles != null)
            {
                foreach (string it in InputSettings.Default.inputFiles)
                {
                    comboBox2.Items.Add(it);
                }
            }
            if(InputSettings.Default.inputFilesDir != null)
            {
                openFileDialog2.InitialDirectory = InputSettings.Default.inputFilesDir;
            }
            if(InputSettings.Default.xsltDir != null)
            {
                openFileDialog1.InitialDirectory = InputSettings.Default.xsltDir;
            }
        }

        private void Main_FormClosing(object sender, FormClosingEventArgs e)
        {
            StringCollection sc1 = new StringCollection();
            foreach (object it in comboBox1.Items)
            {
                if (!sc1.Contains(it.ToString()))
                {
                    sc1.Add(it.ToString());
                }
            }
            InputSettings.Default.xsltFiles = sc1;

            StringCollection sc2 = new StringCollection();
            foreach(object it in comboBox2.Items)
            {
                if(!sc2.Contains(it.ToString()))
                {
                    sc2.Add(it.ToString());
                }
            }
            InputSettings.Default.inputFiles = sc2;
            queryManager.SaveState();
        }

        private void SaveDirectorySetting(string prefix, string filename)
        {
            FileInfo fi = new FileInfo(filename);
            InputSettings.Default[prefix + "Dir"] = fi.DirectoryName;
            InputSettings.Default.Save();
        }

        private void comboBox2_TextChanged(object sender, EventArgs e)
        {
            UpdateInputSelection();
        }

        private void comboBox1_TextChanged(object sender, EventArgs e)
        {
            UpdateXSLTSelection();
        }

        private void bwTransform_DoWork(object sender, DoWorkEventArgs e)
        {
            try
            {
                MemoryStream inStream = new MemoryStream(Encoding.UTF8.GetBytes(e.Argument as string));
                StringBuilder sb = new StringBuilder();
                MemoryStream outStream = new MemoryStream();

                transformer.TransformXML(inStream, outStream);

                MethodInvoker d = delegate ()
                {
                    richTextBox2.Text = Encoding.UTF8.GetString(outStream.ToArray());
                };
                if(InvokeRequired)
                {
                    Invoke(d);
                } else
                {
                    d();
                }

                e.Result = true;
            }
            catch (Exception er)
            {
                MethodInvoker m = delegate ()
                {
                    richTextBox2.Text = er.ToString();
                };
                if(InvokeRequired)
                {
                    Invoke(m);
                }
                else
                {
                    m();
                }
                e.Result = false;
            }
        }

        private void bwTransform_ProgressChanged(object sender, ProgressChangedEventArgs e)
        {

        }

        private void bwTransform_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            CheckCanTransform(true);
        }

        private void bwTransformOpener_DoWork(object sender, DoWorkEventArgs e)
        {
            try
            {
                transformer.AddExtension(new XSLT.Extensions.InterSystems());
                transformer.AddExtension(new XSLT.Extensions.EXSLT.Sets());
                transformer.AddExtension(new XSLT.Extensions.EXSLT.Common());
                transformer.SetSourceXSLT(e.Argument as string);
            } catch (Exception er)
            {
                MethodInvoker d = delegate ()
                {
                    richTextBox2.Text = er.ToString();
                };
                if(InvokeRequired)
                {
                    Invoke(d);
                } else
                {
                    d();
                }
            }
        }

        private void bwTransformOpener_ProgressChanged(object sender, ProgressChangedEventArgs e)
        {

        }

        private void bwTransformOpener_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            button1.Text = "Browse";
            button1.Enabled = true;
            comboBox1.Enabled = true;
            CheckCanTransform();
        }

        private void dataGridView1_DataSourceChanged(object sender, EventArgs e)
        {
            dataGridView1.Invalidate();
        }

        private void dataGridView1_RowsAdded(object sender, DataGridViewRowsAddedEventArgs e)
        {
            
        }
    }
}
