namespace ovrvision_app
{
    partial class SettingForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.buttonOK = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.tbExposure = new System.Windows.Forms.TrackBar();
            this.tboxExposure = new System.Windows.Forms.TextBox();
            this.tbGain = new System.Windows.Forms.TrackBar();
            this.label2 = new System.Windows.Forms.Label();
            this.tboxGain = new System.Windows.Forms.TextBox();
            this.tboxWBRGain = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.tbWBRGain = new System.Windows.Forms.TrackBar();
            this.tboxWBGGain = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.tbWBGGain = new System.Windows.Forms.TrackBar();
            this.tboxWBBGain = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.tbWBBGain = new System.Windows.Forms.TrackBar();
            this.cbWBAuto = new System.Windows.Forms.CheckBox();
            this.tboxBLC = new System.Windows.Forms.TextBox();
            this.label6 = new System.Windows.Forms.Label();
            this.tbBLC = new System.Windows.Forms.TrackBar();
            this.buttonSave = new System.Windows.Forms.Button();
            this.button1_30 = new System.Windows.Forms.Button();
            this.button1_60 = new System.Windows.Forms.Button();
            this.button1_120 = new System.Windows.Forms.Button();
            this.button1_180 = new System.Windows.Forms.Button();
            this.button1_240 = new System.Windows.Forms.Button();
            this.button1_200 = new System.Windows.Forms.Button();
            this.button1_150 = new System.Windows.Forms.Button();
            this.button1_100 = new System.Windows.Forms.Button();
            this.button1_50 = new System.Windows.Forms.Button();
            this.button1_25 = new System.Windows.Forms.Button();
            this.label7 = new System.Windows.Forms.Label();
            this.label8 = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.tbExposure)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.tbGain)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.tbWBRGain)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.tbWBGGain)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.tbWBBGain)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.tbBLC)).BeginInit();
            this.SuspendLayout();
            // 
            // buttonOK
            // 
            this.buttonOK.Location = new System.Drawing.Point(349, 371);
            this.buttonOK.Name = "buttonOK";
            this.buttonOK.Size = new System.Drawing.Size(94, 30);
            this.buttonOK.TabIndex = 0;
            this.buttonOK.Text = "Close";
            this.buttonOK.UseVisualStyleBackColor = true;
            this.buttonOK.Click += new System.EventHandler(this.buttonOK_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(10, 8);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(114, 12);
            this.label1.TabIndex = 1;
            this.label1.Text = "Exposure (0 - 32767)";
            // 
            // tbExposure
            // 
            this.tbExposure.AutoSize = false;
            this.tbExposure.LargeChange = 16;
            this.tbExposure.Location = new System.Drawing.Point(14, 23);
            this.tbExposure.Maximum = 32767;
            this.tbExposure.Name = "tbExposure";
            this.tbExposure.Size = new System.Drawing.Size(331, 21);
            this.tbExposure.SmallChange = 16;
            this.tbExposure.TabIndex = 2;
            this.tbExposure.TickStyle = System.Windows.Forms.TickStyle.None;
            this.tbExposure.Value = 1;
            this.tbExposure.ValueChanged += new System.EventHandler(this.tbExposure_ValueChanged);
            // 
            // tboxExposure
            // 
            this.tboxExposure.Location = new System.Drawing.Point(351, 23);
            this.tboxExposure.MaxLength = 10;
            this.tboxExposure.Name = "tboxExposure";
            this.tboxExposure.ReadOnly = true;
            this.tboxExposure.Size = new System.Drawing.Size(94, 19);
            this.tboxExposure.TabIndex = 3;
            this.tboxExposure.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            // 
            // tbGain
            // 
            this.tbGain.AutoSize = false;
            this.tbGain.LargeChange = 1;
            this.tbGain.Location = new System.Drawing.Point(14, 141);
            this.tbGain.Maximum = 47;
            this.tbGain.Minimum = 1;
            this.tbGain.Name = "tbGain";
            this.tbGain.Size = new System.Drawing.Size(331, 21);
            this.tbGain.TabIndex = 4;
            this.tbGain.TickStyle = System.Windows.Forms.TickStyle.None;
            this.tbGain.Value = 1;
            this.tbGain.ValueChanged += new System.EventHandler(this.tbGain_ValueChanged);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(10, 126);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(72, 12);
            this.label2.TabIndex = 5;
            this.label2.Text = "Gain (1 - 47)";
            // 
            // tboxGain
            // 
            this.tboxGain.Location = new System.Drawing.Point(351, 141);
            this.tboxGain.MaxLength = 10;
            this.tboxGain.Name = "tboxGain";
            this.tboxGain.ReadOnly = true;
            this.tboxGain.Size = new System.Drawing.Size(94, 19);
            this.tboxGain.TabIndex = 6;
            this.tboxGain.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            // 
            // tboxWBRGain
            // 
            this.tboxWBRGain.Location = new System.Drawing.Point(349, 260);
            this.tboxWBRGain.MaxLength = 10;
            this.tboxWBRGain.Name = "tboxWBRGain";
            this.tboxWBRGain.ReadOnly = true;
            this.tboxWBRGain.Size = new System.Drawing.Size(94, 19);
            this.tboxWBRGain.TabIndex = 9;
            this.tboxWBRGain.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(12, 245);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(173, 12);
            this.label3.TabIndex = 8;
            this.label3.Text = "White Balance R Gain (0 - 4095)";
            // 
            // tbWBRGain
            // 
            this.tbWBRGain.AutoSize = false;
            this.tbWBRGain.LargeChange = 1;
            this.tbWBRGain.Location = new System.Drawing.Point(12, 260);
            this.tbWBRGain.Maximum = 4095;
            this.tbWBRGain.Name = "tbWBRGain";
            this.tbWBRGain.Size = new System.Drawing.Size(331, 21);
            this.tbWBRGain.TabIndex = 7;
            this.tbWBRGain.TickStyle = System.Windows.Forms.TickStyle.None;
            this.tbWBRGain.ValueChanged += new System.EventHandler(this.tbWBRGain_ValueChanged);
            // 
            // tboxWBGGain
            // 
            this.tboxWBGGain.Location = new System.Drawing.Point(349, 296);
            this.tboxWBGGain.MaxLength = 10;
            this.tboxWBGGain.Name = "tboxWBGGain";
            this.tboxWBGGain.ReadOnly = true;
            this.tboxWBGGain.Size = new System.Drawing.Size(94, 19);
            this.tboxWBGGain.TabIndex = 12;
            this.tboxWBGGain.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(12, 281);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(173, 12);
            this.label4.TabIndex = 11;
            this.label4.Text = "White Balance G Gain (0 - 4095)";
            // 
            // tbWBGGain
            // 
            this.tbWBGGain.AutoSize = false;
            this.tbWBGGain.LargeChange = 1;
            this.tbWBGGain.Location = new System.Drawing.Point(12, 296);
            this.tbWBGGain.Maximum = 4095;
            this.tbWBGGain.Name = "tbWBGGain";
            this.tbWBGGain.Size = new System.Drawing.Size(331, 21);
            this.tbWBGGain.TabIndex = 10;
            this.tbWBGGain.TickStyle = System.Windows.Forms.TickStyle.None;
            this.tbWBGGain.ValueChanged += new System.EventHandler(this.tbWBGGain_ValueChanged);
            // 
            // tboxWBBGain
            // 
            this.tboxWBBGain.Location = new System.Drawing.Point(349, 333);
            this.tboxWBBGain.MaxLength = 10;
            this.tboxWBBGain.Name = "tboxWBBGain";
            this.tboxWBBGain.ReadOnly = true;
            this.tboxWBBGain.Size = new System.Drawing.Size(94, 19);
            this.tboxWBBGain.TabIndex = 15;
            this.tboxWBBGain.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(12, 318);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(173, 12);
            this.label5.TabIndex = 14;
            this.label5.Text = "White Balance B Gain (0 - 4095)";
            // 
            // tbWBBGain
            // 
            this.tbWBBGain.AutoSize = false;
            this.tbWBBGain.LargeChange = 1;
            this.tbWBBGain.Location = new System.Drawing.Point(12, 333);
            this.tbWBBGain.Maximum = 4095;
            this.tbWBBGain.Name = "tbWBBGain";
            this.tbWBBGain.Size = new System.Drawing.Size(331, 21);
            this.tbWBBGain.TabIndex = 13;
            this.tbWBBGain.TickStyle = System.Windows.Forms.TickStyle.None;
            this.tbWBBGain.ValueChanged += new System.EventHandler(this.tbWBBGain_ValueChanged);
            // 
            // cbWBAuto
            // 
            this.cbWBAuto.AutoSize = true;
            this.cbWBAuto.Location = new System.Drawing.Point(14, 220);
            this.cbWBAuto.Name = "cbWBAuto";
            this.cbWBAuto.Size = new System.Drawing.Size(152, 16);
            this.cbWBAuto.TabIndex = 17;
            this.cbWBAuto.Text = "White Balance Auto Gain";
            this.cbWBAuto.UseVisualStyleBackColor = true;
            this.cbWBAuto.CheckedChanged += new System.EventHandler(this.cbWBAuto_CheckedChanged);
            // 
            // tboxBLC
            // 
            this.tboxBLC.Location = new System.Drawing.Point(351, 178);
            this.tboxBLC.MaxLength = 10;
            this.tboxBLC.Name = "tboxBLC";
            this.tboxBLC.ReadOnly = true;
            this.tboxBLC.Size = new System.Drawing.Size(94, 19);
            this.tboxBLC.TabIndex = 20;
            this.tboxBLC.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(12, 163);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(185, 12);
            this.label6.TabIndex = 19;
            this.label6.Text = "Backlight Compensation (0 - 1023)";
            // 
            // tbBLC
            // 
            this.tbBLC.AutoSize = false;
            this.tbBLC.LargeChange = 1;
            this.tbBLC.Location = new System.Drawing.Point(14, 178);
            this.tbBLC.Maximum = 1023;
            this.tbBLC.Name = "tbBLC";
            this.tbBLC.Size = new System.Drawing.Size(331, 21);
            this.tbBLC.TabIndex = 18;
            this.tbBLC.TickStyle = System.Windows.Forms.TickStyle.None;
            this.tbBLC.Value = 1;
            this.tbBLC.ValueChanged += new System.EventHandler(this.tbBLC_ValueChanged);
            // 
            // buttonSave
            // 
            this.buttonSave.Location = new System.Drawing.Point(14, 371);
            this.buttonSave.Name = "buttonSave";
            this.buttonSave.Size = new System.Drawing.Size(110, 30);
            this.buttonSave.TabIndex = 21;
            this.buttonSave.Text = "Save EEPROM";
            this.buttonSave.UseVisualStyleBackColor = true;
            this.buttonSave.Click += new System.EventHandler(this.buttonSave_Click);
            // 
            // button1_30
            // 
            this.button1_30.Location = new System.Drawing.Point(47, 50);
            this.button1_30.Name = "button1_30";
            this.button1_30.Size = new System.Drawing.Size(75, 23);
            this.button1_30.TabIndex = 22;
            this.button1_30.Text = "1 / 30";
            this.button1_30.UseVisualStyleBackColor = true;
            this.button1_30.Click += new System.EventHandler(this.button1_30_Click);
            // 
            // button1_60
            // 
            this.button1_60.Location = new System.Drawing.Point(128, 50);
            this.button1_60.Name = "button1_60";
            this.button1_60.Size = new System.Drawing.Size(75, 23);
            this.button1_60.TabIndex = 23;
            this.button1_60.Text = "1 / 60";
            this.button1_60.UseVisualStyleBackColor = true;
            this.button1_60.Click += new System.EventHandler(this.button1_60_Click);
            // 
            // button1_120
            // 
            this.button1_120.Location = new System.Drawing.Point(209, 50);
            this.button1_120.Name = "button1_120";
            this.button1_120.Size = new System.Drawing.Size(75, 23);
            this.button1_120.TabIndex = 24;
            this.button1_120.Text = "1 / 120";
            this.button1_120.UseVisualStyleBackColor = true;
            this.button1_120.Click += new System.EventHandler(this.button1_120_Click);
            // 
            // button1_180
            // 
            this.button1_180.Location = new System.Drawing.Point(290, 50);
            this.button1_180.Name = "button1_180";
            this.button1_180.Size = new System.Drawing.Size(75, 23);
            this.button1_180.TabIndex = 25;
            this.button1_180.Text = "1 / 180";
            this.button1_180.UseVisualStyleBackColor = true;
            this.button1_180.Click += new System.EventHandler(this.button1_180_Click);
            // 
            // button1_240
            // 
            this.button1_240.Location = new System.Drawing.Point(371, 50);
            this.button1_240.Name = "button1_240";
            this.button1_240.Size = new System.Drawing.Size(75, 23);
            this.button1_240.TabIndex = 26;
            this.button1_240.Text = "1 / 240";
            this.button1_240.UseVisualStyleBackColor = true;
            this.button1_240.Click += new System.EventHandler(this.button1_240_Click);
            // 
            // button1_200
            // 
            this.button1_200.Location = new System.Drawing.Point(371, 79);
            this.button1_200.Name = "button1_200";
            this.button1_200.Size = new System.Drawing.Size(75, 23);
            this.button1_200.TabIndex = 31;
            this.button1_200.Text = "1 / 200";
            this.button1_200.UseVisualStyleBackColor = true;
            this.button1_200.Click += new System.EventHandler(this.button1_200_Click);
            // 
            // button1_150
            // 
            this.button1_150.Location = new System.Drawing.Point(290, 79);
            this.button1_150.Name = "button1_150";
            this.button1_150.Size = new System.Drawing.Size(75, 23);
            this.button1_150.TabIndex = 30;
            this.button1_150.Text = "1 / 150";
            this.button1_150.UseVisualStyleBackColor = true;
            this.button1_150.Click += new System.EventHandler(this.button1_150_Click);
            // 
            // button1_100
            // 
            this.button1_100.Location = new System.Drawing.Point(209, 79);
            this.button1_100.Name = "button1_100";
            this.button1_100.Size = new System.Drawing.Size(75, 23);
            this.button1_100.TabIndex = 29;
            this.button1_100.Text = "1 / 100";
            this.button1_100.UseVisualStyleBackColor = true;
            this.button1_100.Click += new System.EventHandler(this.button1_100_Click);
            // 
            // button1_50
            // 
            this.button1_50.Location = new System.Drawing.Point(128, 79);
            this.button1_50.Name = "button1_50";
            this.button1_50.Size = new System.Drawing.Size(75, 23);
            this.button1_50.TabIndex = 28;
            this.button1_50.Text = "1 / 50";
            this.button1_50.UseVisualStyleBackColor = true;
            this.button1_50.Click += new System.EventHandler(this.button1_50_Click);
            // 
            // button1_25
            // 
            this.button1_25.Location = new System.Drawing.Point(47, 79);
            this.button1_25.Name = "button1_25";
            this.button1_25.Size = new System.Drawing.Size(75, 23);
            this.button1_25.TabIndex = 27;
            this.button1_25.Text = "1 / 25";
            this.button1_25.UseVisualStyleBackColor = true;
            this.button1_25.Click += new System.EventHandler(this.button1_25_Click);
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(12, 55);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(30, 12);
            this.label7.TabIndex = 32;
            this.label7.Text = "60Hz";
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(12, 84);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(30, 12);
            this.label8.TabIndex = 33;
            this.label8.Text = "50Hz";
            // 
            // SettingForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(455, 413);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.button1_200);
            this.Controls.Add(this.button1_150);
            this.Controls.Add(this.button1_100);
            this.Controls.Add(this.button1_50);
            this.Controls.Add(this.button1_25);
            this.Controls.Add(this.button1_240);
            this.Controls.Add(this.button1_180);
            this.Controls.Add(this.button1_120);
            this.Controls.Add(this.button1_60);
            this.Controls.Add(this.button1_30);
            this.Controls.Add(this.buttonSave);
            this.Controls.Add(this.tboxBLC);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.tbBLC);
            this.Controls.Add(this.cbWBAuto);
            this.Controls.Add(this.tboxWBBGain);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.tbWBBGain);
            this.Controls.Add(this.tboxWBGGain);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.tbWBGGain);
            this.Controls.Add(this.tboxWBRGain);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.tbWBRGain);
            this.Controls.Add(this.tboxGain);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.tbGain);
            this.Controls.Add(this.tboxExposure);
            this.Controls.Add(this.tbExposure);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.buttonOK);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedToolWindow;
            this.Name = "SettingForm";
            this.Text = "OvrvisionPro Camera Setting";
            ((System.ComponentModel.ISupportInitialize)(this.tbExposure)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.tbGain)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.tbWBRGain)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.tbWBGGain)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.tbWBBGain)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.tbBLC)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button buttonOK;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TrackBar tbExposure;
        private System.Windows.Forms.TextBox tboxExposure;
        private System.Windows.Forms.TrackBar tbGain;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox tboxGain;
        private System.Windows.Forms.TextBox tboxWBRGain;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TrackBar tbWBRGain;
        private System.Windows.Forms.TextBox tboxWBGGain;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TrackBar tbWBGGain;
        private System.Windows.Forms.TextBox tboxWBBGain;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TrackBar tbWBBGain;
        private System.Windows.Forms.CheckBox cbWBAuto;
        private System.Windows.Forms.TextBox tboxBLC;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.TrackBar tbBLC;
        private System.Windows.Forms.Button buttonSave;
        private System.Windows.Forms.Button button1_30;
        private System.Windows.Forms.Button button1_60;
        private System.Windows.Forms.Button button1_120;
        private System.Windows.Forms.Button button1_180;
        private System.Windows.Forms.Button button1_240;
        private System.Windows.Forms.Button button1_200;
        private System.Windows.Forms.Button button1_150;
        private System.Windows.Forms.Button button1_100;
        private System.Windows.Forms.Button button1_50;
        private System.Windows.Forms.Button button1_25;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Label label8;
    }
}