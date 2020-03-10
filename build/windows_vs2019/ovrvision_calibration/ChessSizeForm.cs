using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace ovrvision_calibration
{
    public partial class ChessSizeForm : Form
    {
        public ChessSizeForm()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Close();
        }

        public float GetTileSize()
        {
            return float.Parse(textBox1.Text);
        }
    }
}
