using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Threading;

namespace ovrvision_app
{
	public partial class MFrom : Form
	{
		//Ovrvision Class
		COvrvision Ovrvision = null;
		//Thread
		Thread UpdateThread = null;
        bool ThreadEnd = false;

        //SettingForm
        SettingForm settingForm;

		public MFrom()
		{
			InitializeComponent();

			//Create Ovrvision Class
			Ovrvision = new COvrvision();
			comboBox1.SelectedIndex = 0;	//DEMOSAIC & REMAP
            comboBoxTYPE.SelectedIndex = COvrvision.OV_CAMHD_FULL;
            comboBoxSize.SelectedIndex = 0;

            settingForm = new SettingForm(Ovrvision);
		}
        private void runbutton_Click(object sender, EventArgs e)
        {
            if (runbutton.Text == "Open Ovrvision")
            {
                if (Ovrvision.Open(comboBoxTYPE.SelectedIndex))
                {	//true
                    statelabel.Text = "State : Opened";
                    runbutton.Text = "Close Ovrvision";

                    cameraPicLeft.Image = Ovrvision.imageDataLeft;	//(BGR)
                    cameraPicRight.Image = Ovrvision.imageDataRight;

                    comboBoxTYPE.Enabled = false;
                    buttonSetting.Enabled = true;
                }
                else
                {	//false
                    statelabel.Text = "State : Open Error.";
                }

                //Thread start
				ThreadEnd = false;
                UpdateThread = new Thread(new ThreadStart(MForm_UpdateThread));
                UpdateThread.Start();
            }
            else
            {
                ThreadEnd = true;
                UpdateThread.Join();
                if (Ovrvision.Close())
                {
                    statelabel.Text = "State : Closed";
                    runbutton.Text = "Open Ovrvision";
                    cameraPicRight.Image = null;
                    cameraPicLeft.Image = null;

                    comboBoxTYPE.Enabled = true;
                    buttonSetting.Enabled = false;

                    UpdateThread = null;
                }
            }
        }

        private void MFrom_FormClosed(object sender, FormClosedEventArgs e)
        {
            if (runbutton.Text != "Open Ovrvision")
            {
                //Close
                ThreadEnd = true;
                UpdateThread.Join();
                if (Ovrvision.Close())
                {
                    statelabel.Text = "State : Closed";
                    runbutton.Text = "Open Ovrvision";
                    cameraPicRight.Image = null;
                    cameraPicLeft.Image = null;

                    comboBoxTYPE.Enabled = true;
                    buttonSetting.Enabled = false;

                    UpdateThread = null;
                }
            }

            Ovrvision.Release();
        }

		private volatile bool UPDATE_LEFTDATA = false;
		private volatile bool UPDATE_RIGHTDATA = false;

		//Update Thread
		private void MForm_UpdateThread()
		{
            while (!ThreadEnd)
			{
				Ovrvision.UpdateCamera();

				UPDATE_LEFTDATA = true;
				UPDATE_RIGHTDATA = true;

				cameraPicLeft.Invalidate();
				cameraPicRight.Invalidate();

                while (UPDATE_LEFTDATA || UPDATE_RIGHTDATA)
                    Thread.Sleep(2);    //2ms
			}
		}

		private void cameraPicLeft_Paint(object sender, PaintEventArgs e)
		{
			Ovrvision.UpdateLeft();
            UPDATE_LEFTDATA = false;

		}

		private void cameraPicRight_Paint(object sender, PaintEventArgs e)
		{
			Ovrvision.UpdateRight();
            UPDATE_RIGHTDATA = false;
		}

		private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
		{
			if (Ovrvision != null)
			{
				Ovrvision.useProcessingQuality = comboBox1.SelectedIndex;
			}
        }

        private void comboBoxSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            switch (comboBoxSize.SelectedIndex)
            {
                case 0:
                    cameraPicLeft.SizeMode = PictureBoxSizeMode.CenterImage;
                    cameraPicRight.SizeMode = PictureBoxSizeMode.CenterImage;
                    break;
                case 1:
                    cameraPicLeft.SizeMode = PictureBoxSizeMode.Zoom;
                    cameraPicRight.SizeMode = PictureBoxSizeMode.Zoom;
                    break;
            }

        }

        private void buttonSetting_Click(object sender, EventArgs e)
        {
            if (!settingForm.Visible) {
                settingForm.ApplyItem();
                settingForm.Show();
            }
        }
	}
}
