using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace ovrvision_app
{
    public partial class SettingForm : Form
    {
        private COvrvision ovrSys;

        public SettingForm(COvrvision system)
        {
            ovrSys = system;
            InitializeComponent();
        }

        public void ApplyItem()
        {
            tbExposure.Value = ovrSys.GetExposure();
            tbGain.Value = ovrSys.GetGain();
            tbBLC.Value = ovrSys.GetBLC();
            tbWBRGain.Value = ovrSys.GetWhiteBalanceR();
            tbWBGGain.Value = ovrSys.GetWhiteBalanceG();
            tbWBBGain.Value = ovrSys.GetWhiteBalanceB();
            cbWBAuto.Checked = ovrSys.GetWhiteBalanceAutoMode();
        }

        private void buttonOK_Click(object sender, EventArgs e)
        {
            Hide(); //hide
        }

        private void tbExposure_ValueChanged(object sender, EventArgs e)
        {
            tboxExposure.Text = tbExposure.Value.ToString();
            ovrSys.SetExposure(tbExposure.Value);
        }

        private void tbGain_ValueChanged(object sender, EventArgs e)
        {
            tboxGain.Text = tbGain.Value.ToString();
            ovrSys.SetGain(tbGain.Value);
        }

        private void tbBLC_ValueChanged(object sender, EventArgs e)
        {
            tboxBLC.Text = tbBLC.Value.ToString();
            ovrSys.SetBLC(tbBLC.Value);
        }

        private void tbWBRGain_ValueChanged(object sender, EventArgs e)
        {
            tboxWBRGain.Text = tbWBRGain.Value.ToString();
            ovrSys.SetWhiteBalanceR(tbWBRGain.Value);
        }

        private void tbWBGGain_ValueChanged(object sender, EventArgs e)
        {
            tboxWBGGain.Text = tbWBGGain.Value.ToString();
            ovrSys.SetWhiteBalanceG(tbWBGGain.Value);
        }

        private void tbWBBGain_ValueChanged(object sender, EventArgs e)
        {
            tboxWBBGain.Text = tbWBBGain.Value.ToString();
            ovrSys.SetWhiteBalanceB(tbWBBGain.Value);
        }

        private void cbWBAuto_CheckedChanged(object sender, EventArgs e)
        {
            if (cbWBAuto.Checked)
            {
                tbWBRGain.Enabled = false;
                tbWBGGain.Enabled = false;
                tbWBBGain.Enabled = false;
            }
            else
            {
                tbWBRGain.Enabled = true;
                tbWBGGain.Enabled = true;
                tbWBBGain.Enabled = true;
            }

            ovrSys.SetWhiteBalanceAutoMode(cbWBAuto.Checked);
        }

        private void buttonSave_Click(object sender, EventArgs e)
        {
            if (ovrSys.SaveCamStatusToEEPROM()) {
                System.Windows.Forms.MessageBox.Show(this, "The camera setting was saved successfully.", "OvrvisionPro");
            }
        }
    }
}
