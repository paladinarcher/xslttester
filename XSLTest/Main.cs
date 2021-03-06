﻿using System;
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
using ScintillaNET;
using ScintillaNET_FindReplaceDialog;
using System.Diagnostics;

namespace XSLTest
{
    public partial class Main : Form
    {
        private Transformer transformer;
        private QueryManager queryManager;
        private Stopwatch stopWatch;
        private int count = 0;
        private long totalMilliseconds = 0;

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
            scintillaStyles();
            findReplace1.Scintilla = richTextBox1;
            findReplace1.KeyPressed += FindReplace1_KeyPressed;
            stopWatch = new Stopwatch();
        }

        private void FindReplace1_KeyPressed(object sender, KeyEventArgs e)
        {
            genericScintilla_KeyDown(sender, e);
        }

        private void scintillaStyles()
        {
            setupSingleScintilla(richTextBox1);
            setupSingleScintilla(richTextBox2);
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
                button4.Enabled = false;
                comboBox1.Enabled = false;
                transformer = new Transformer();
                queryManager.ChangeQuery(comboBox1.Text);
                transformer.AddArguments(queryManager.CurrentTable);
                transformer.OnParameterEmergencyAdd += Transformer_OnParameterEmergencyAdd;
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

        private void Transformer_OnParameterEmergencyAdd(object sender, OnParameterEmergencyArgs e)
        {
            object s = bindingSource1.DataSource;
            if(s != null)
            {
                QueryParamsTable t = (QueryParamsTable)s;
                DataRow row  = t.NewRow();
                row["Name"]  = e.Name;
                row["Value"] = e.Value;
                t.Rows.Add(row);
                dataGridView1.Invalidate();
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
                        totalMilliseconds = 0;
                        count = 0;

                        lblCount.Text = count.ToString();
                        lblLastTime.Text = totalMilliseconds.ToString("N");
                        lblTotal.Text = totalMilliseconds.ToString("N");
                        lblAvg.Text = totalMilliseconds.ToString("N");
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

                count++;
                stopWatch.Reset();
                stopWatch.Start();
                transformer.TransformXML(inStream, outStream);
                stopWatch.Stop();
                long millis = stopWatch.ElapsedMilliseconds;
                totalMilliseconds += millis;

                MethodInvoker d = delegate ()
                {
                    richTextBox2.Text = Encoding.UTF8.GetString(outStream.ToArray());
                    lblCount.Text = count.ToString();
                    lblLastTime.Text = millis.ToString("N");
                    lblTotal.Text = totalMilliseconds.ToString("N");
                    lblAvg.Text = (totalMilliseconds / count).ToString("N");
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
            string text = "";
            try
            {
                transformer.AddExtension(new XSLT.Extensions.InterSystems());
                transformer.AddExtension(new XSLT.Extensions.EXSLT.Sets());
                transformer.AddExtension(new XSLT.Extensions.EXSLT.Common());
                transformer.AddExtension(new XSLT.Extensions.EXSLT.Dates());
                transformer.AddExtension(new XSLT.Extensions.EXSLT.Strings());
                transformer.SetSourceXSLT(e.Argument as string);
            } catch (Exception er)
            {
                text = er.ToString();
            }
            MethodInvoker d = delegate ()
            {
                richTextBox2.Text = text;
                totalMilliseconds = 0;
                count = 0;

                lblCount.Text = count.ToString();
                lblLastTime.Text = totalMilliseconds.ToString("N");
                lblTotal.Text = totalMilliseconds.ToString("N");
                lblAvg.Text = totalMilliseconds.ToString("N");
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

        private void bwTransformOpener_ProgressChanged(object sender, ProgressChangedEventArgs e)
        {

        }

        private void bwTransformOpener_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            button1.Text = "Browse";
            button1.Enabled = true;
            button4.Enabled = true;
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

        private void button4_Click(object sender, EventArgs e)
        {
            UpdateXSLTSelection();
        }

        private void setupSingleScintilla(Scintilla scintilla)
        {
            // Reset the styles
            scintilla.StyleResetDefault();
            scintilla.Styles[Style.Default].Font = "Consolas";
            scintilla.Styles[Style.Default].Size = 9;
            scintilla.StyleClearAll();

            // Set the XML Lexer
            scintilla.Lexer = Lexer.Xml;

            // Show line numbers
            scintilla.Margins[0].Width = 40;

            // Enable folding
            scintilla.SetProperty("fold", "1");
            scintilla.SetProperty("fold.compact", "1");
            scintilla.SetProperty("fold.html", "1");

            // Use Margin 2 for fold markers
            scintilla.Margins[2].Type = MarginType.Symbol;
            scintilla.Margins[2].Mask = Marker.MaskFolders;
            scintilla.Margins[2].Sensitive = true;
            scintilla.Margins[2].Width = 20;

            // Reset folder markers
            for (int i = Marker.FolderEnd; i <= Marker.FolderOpen; i++)
            {
                scintilla.Markers[i].SetForeColor(SystemColors.ControlLightLight);
                scintilla.Markers[i].SetBackColor(SystemColors.ControlDark);
            }

            // Style the folder markers
            scintilla.Markers[Marker.Folder].Symbol = MarkerSymbol.BoxPlus;
            scintilla.Markers[Marker.Folder].SetBackColor(SystemColors.ControlText);
            scintilla.Markers[Marker.FolderOpen].Symbol = MarkerSymbol.BoxMinus;
            scintilla.Markers[Marker.FolderEnd].Symbol = MarkerSymbol.BoxPlusConnected;
            scintilla.Markers[Marker.FolderEnd].SetBackColor(SystemColors.ControlText);
            scintilla.Markers[Marker.FolderMidTail].Symbol = MarkerSymbol.TCorner;
            scintilla.Markers[Marker.FolderOpenMid].Symbol = MarkerSymbol.BoxMinusConnected;
            scintilla.Markers[Marker.FolderSub].Symbol = MarkerSymbol.VLine;
            scintilla.Markers[Marker.FolderTail].Symbol = MarkerSymbol.LCorner;

            // Enable automatic folding
            scintilla.AutomaticFold = AutomaticFold.Show | AutomaticFold.Click | AutomaticFold.Change;

            // Set the Styles
            scintilla.StyleResetDefault();
            // I like fixed font for XML
            scintilla.Styles[Style.Default].Font = "Courier";
            scintilla.Styles[Style.Default].Size = 10;
            scintilla.StyleClearAll();
            scintilla.Styles[Style.Xml.Attribute].ForeColor = Color.Red;
            scintilla.Styles[Style.Xml.Entity].ForeColor = Color.Red;
            scintilla.Styles[Style.Xml.Comment].ForeColor = Color.Green;
            scintilla.Styles[Style.Xml.Tag].ForeColor = Color.Blue;
            scintilla.Styles[Style.Xml.TagEnd].ForeColor = Color.Blue;
            scintilla.Styles[Style.Xml.DoubleString].ForeColor = Color.DeepPink;
            scintilla.Styles[Style.Xml.SingleString].ForeColor = Color.DeepPink;
        }

        private void richTextBox_Enter(object sender, EventArgs e)
        {
            findReplace1.Scintilla = (Scintilla)sender;
        }

        /// <summary>
        /// Key down event for each Scintilla. Tie each Scintilla to this event
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void genericScintilla_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Control && e.KeyCode == Keys.F)
            {
                findReplace1.ShowFind();
                e.SuppressKeyPress = true;
            }
            else if (e.Shift && e.KeyCode == Keys.F3)
            {
                findReplace1.Window.FindPrevious();
                e.SuppressKeyPress = true;
            }
            else if (e.KeyCode == Keys.F3)
            {
                findReplace1.Window.FindNext();
                e.SuppressKeyPress = true;
            }
            else if (e.Control && e.KeyCode == Keys.H)
            {
                findReplace1.ShowReplace();
                e.SuppressKeyPress = true;
            }
            else if (e.Control && e.KeyCode == Keys.I)
            {
                findReplace1.ShowIncrementalSearch();
                e.SuppressKeyPress = true;
            }
            else if (e.Control && e.KeyCode == Keys.G)
            {
                GoTo MyGoTo = new GoTo((Scintilla)sender);
                MyGoTo.ShowGoToDialog();
                e.SuppressKeyPress = true;
            }
        }

        /// <summary>
        /// Enter event tied to each Scintilla that will share a FindReplace dialog.
        /// Tie each Scintilla to this event.
        /// </summary>
        /// <param name="sender">The Scintilla receiving focus</param>
        /// <param name="e"></param>
        private void genericScintilla1_Enter(object sender, EventArgs e)
        {
            findReplace1.Scintilla = (Scintilla)sender;
        }
    }
}
