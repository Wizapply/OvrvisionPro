namespace ovrvision_app
{
	partial class MFrom
	{
		/// <summary>
		/// 必要なデザイナ変数です。
		/// </summary>
		private System.ComponentModel.IContainer components = null;

		/// <summary>
		/// 使用中のリソースをすべてクリーンアップします。
		/// </summary>
		/// <param name="disposing">マネージ リソースが破棄される場合 true、破棄されない場合は false です。</param>
		protected override void Dispose(bool disposing)
		{
			if (disposing && (components != null))
			{
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		#region Windows フォーム デザイナで生成されたコード

		/// <summary>
		/// デザイナ サポートに必要なメソッドです。このメソッドの内容を
		/// コード エディタで変更しないでください。
		/// </summary>
		private void InitializeComponent()
		{
            this.runbutton = new System.Windows.Forms.Button();
            this.statelabel = new System.Windows.Forms.Label();
            this.cameraPicLeft = new System.Windows.Forms.PictureBox();
            this.cameraPicRight = new System.Windows.Forms.PictureBox();
            this.splitContainer = new System.Windows.Forms.SplitContainer();
            this.comboBox1 = new System.Windows.Forms.ComboBox();
            this.label1 = new System.Windows.Forms.Label();
            this.comboBoxTYPE = new System.Windows.Forms.ComboBox();
            this.label2 = new System.Windows.Forms.Label();
            this.comboBoxSize = new System.Windows.Forms.ComboBox();
            this.buttonSetting = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.cameraPicLeft)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.cameraPicRight)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer)).BeginInit();
            this.splitContainer.Panel1.SuspendLayout();
            this.splitContainer.Panel2.SuspendLayout();
            this.splitContainer.SuspendLayout();
            this.SuspendLayout();
            // 
            // runbutton
            // 
            this.runbutton.Location = new System.Drawing.Point(144, 8);
            this.runbutton.Name = "runbutton";
            this.runbutton.Size = new System.Drawing.Size(132, 29);
            this.runbutton.TabIndex = 0;
            this.runbutton.Text = "Open Ovrvision";
            this.runbutton.UseVisualStyleBackColor = true;
            this.runbutton.Click += new System.EventHandler(this.runbutton_Click);
            // 
            // statelabel
            // 
            this.statelabel.AutoSize = true;
            this.statelabel.Location = new System.Drawing.Point(282, 17);
            this.statelabel.Name = "statelabel";
            this.statelabel.Size = new System.Drawing.Size(77, 12);
            this.statelabel.TabIndex = 1;
            this.statelabel.Text = "State : Closed";
            // 
            // cameraPicLeft
            // 
            this.cameraPicLeft.BackColor = System.Drawing.Color.Black;
            this.cameraPicLeft.Dock = System.Windows.Forms.DockStyle.Fill;
            this.cameraPicLeft.Location = new System.Drawing.Point(0, 0);
            this.cameraPicLeft.Name = "cameraPicLeft";
            this.cameraPicLeft.Size = new System.Drawing.Size(673, 524);
            this.cameraPicLeft.SizeMode = System.Windows.Forms.PictureBoxSizeMode.CenterImage;
            this.cameraPicLeft.TabIndex = 2;
            this.cameraPicLeft.TabStop = false;
            this.cameraPicLeft.Paint += new System.Windows.Forms.PaintEventHandler(this.cameraPicLeft_Paint);
            // 
            // cameraPicRight
            // 
            this.cameraPicRight.BackColor = System.Drawing.Color.Black;
            this.cameraPicRight.Dock = System.Windows.Forms.DockStyle.Fill;
            this.cameraPicRight.Location = new System.Drawing.Point(0, 0);
            this.cameraPicRight.Name = "cameraPicRight";
            this.cameraPicRight.Size = new System.Drawing.Size(677, 524);
            this.cameraPicRight.SizeMode = System.Windows.Forms.PictureBoxSizeMode.CenterImage;
            this.cameraPicRight.TabIndex = 3;
            this.cameraPicRight.TabStop = false;
            this.cameraPicRight.Paint += new System.Windows.Forms.PaintEventHandler(this.cameraPicRight_Paint);
            // 
            // splitContainer
            // 
            this.splitContainer.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.splitContainer.Location = new System.Drawing.Point(12, 47);
            this.splitContainer.Name = "splitContainer";
            // 
            // splitContainer.Panel1
            // 
            this.splitContainer.Panel1.Controls.Add(this.cameraPicLeft);
            // 
            // splitContainer.Panel2
            // 
            this.splitContainer.Panel2.Controls.Add(this.cameraPicRight);
            this.splitContainer.Size = new System.Drawing.Size(1354, 524);
            this.splitContainer.SplitterDistance = 673;
            this.splitContainer.TabIndex = 4;
            // 
            // comboBox1
            // 
            this.comboBox1.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.comboBox1.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBox1.FormattingEnabled = true;
            this.comboBox1.Items.AddRange(new object[] {
            "DEMOSAIC&REMAP",
            "DEMOSAIC",
            "NONE"});
            this.comboBox1.Location = new System.Drawing.Point(1061, 17);
            this.comboBox1.Name = "comboBox1";
            this.comboBox1.Size = new System.Drawing.Size(147, 20);
            this.comboBox1.TabIndex = 5;
            this.comboBox1.SelectedIndexChanged += new System.EventHandler(this.comboBox1_SelectedIndexChanged);
            // 
            // label1
            // 
            this.label1.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(948, 20);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(107, 12);
            this.label1.TabIndex = 6;
            this.label1.Text = "Processing Quality :";
            // 
            // comboBoxTYPE
            // 
            this.comboBoxTYPE.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBoxTYPE.FormattingEnabled = true;
            this.comboBoxTYPE.Items.AddRange(new object[] {
            "2560x1920@15",
            "1920x1080@30",
            "1280x960@45",
            "960x950@60",
            "1280x800@60",
            "640x480@90",
            "320x240@120"});
            this.comboBoxTYPE.Location = new System.Drawing.Point(12, 12);
            this.comboBoxTYPE.Name = "comboBoxTYPE";
            this.comboBoxTYPE.Size = new System.Drawing.Size(126, 20);
            this.comboBoxTYPE.TabIndex = 7;
            // 
            // label2
            // 
            this.label2.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(1214, 20);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(63, 12);
            this.label2.TabIndex = 8;
            this.label2.Text = "ViewMode :";
            // 
            // comboBoxSize
            // 
            this.comboBoxSize.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.comboBoxSize.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBoxSize.FormattingEnabled = true;
            this.comboBoxSize.Items.AddRange(new object[] {
            "ACTUAL",
            "FULL"});
            this.comboBoxSize.Location = new System.Drawing.Point(1283, 17);
            this.comboBoxSize.Name = "comboBoxSize";
            this.comboBoxSize.Size = new System.Drawing.Size(83, 20);
            this.comboBoxSize.TabIndex = 9;
            this.comboBoxSize.SelectedIndexChanged += new System.EventHandler(this.comboBoxSize_SelectedIndexChanged);
            // 
            // buttonSetting
            // 
            this.buttonSetting.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.buttonSetting.Enabled = false;
            this.buttonSetting.Location = new System.Drawing.Point(842, 9);
            this.buttonSetting.Name = "buttonSetting";
            this.buttonSetting.Size = new System.Drawing.Size(100, 29);
            this.buttonSetting.TabIndex = 10;
            this.buttonSetting.Text = "Camera Setting";
            this.buttonSetting.UseVisualStyleBackColor = true;
            this.buttonSetting.Click += new System.EventHandler(this.buttonSetting_Click);
            // 
            // MFrom
            // 
            this.AcceptButton = this.runbutton;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1378, 583);
            this.Controls.Add(this.buttonSetting);
            this.Controls.Add(this.comboBoxSize);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.comboBoxTYPE);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.comboBox1);
            this.Controls.Add(this.splitContainer);
            this.Controls.Add(this.statelabel);
            this.Controls.Add(this.runbutton);
            this.Name = "MFrom";
            this.Text = "Ovrvision Application";
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.MFrom_FormClosed);
            ((System.ComponentModel.ISupportInitialize)(this.cameraPicLeft)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.cameraPicRight)).EndInit();
            this.splitContainer.Panel1.ResumeLayout(false);
            this.splitContainer.Panel2.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer)).EndInit();
            this.splitContainer.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

		}

		#endregion

		private System.Windows.Forms.Button runbutton;
		private System.Windows.Forms.Label statelabel;
		private System.Windows.Forms.PictureBox cameraPicLeft;
		private System.Windows.Forms.PictureBox cameraPicRight;
		private System.Windows.Forms.SplitContainer splitContainer;
		private System.Windows.Forms.ComboBox comboBox1;
		private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ComboBox comboBoxTYPE;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.ComboBox comboBoxSize;
        private System.Windows.Forms.Button buttonSetting;
	}
}

