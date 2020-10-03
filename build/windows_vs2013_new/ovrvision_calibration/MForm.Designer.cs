namespace ovrvision_calibration
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
            this.cabliButton = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.chessPicture = new System.Windows.Forms.PictureBox();
            this.cameraPicRight = new System.Windows.Forms.PictureBox();
            this.cameraPicLeft = new System.Windows.Forms.PictureBox();
            this.buttonSetting = new System.Windows.Forms.Button();
            this.opfCheckBox = new System.Windows.Forms.CheckBox();
            ((System.ComponentModel.ISupportInitialize)(this.chessPicture)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.cameraPicRight)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.cameraPicLeft)).BeginInit();
            this.SuspendLayout();
            // 
            // runbutton
            // 
            this.runbutton.Location = new System.Drawing.Point(12, 12);
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
            this.statelabel.Location = new System.Drawing.Point(288, 20);
            this.statelabel.Name = "statelabel";
            this.statelabel.Size = new System.Drawing.Size(77, 12);
            this.statelabel.TabIndex = 1;
            this.statelabel.Text = "State : Closed";
            // 
            // cabliButton
            // 
            this.cabliButton.Enabled = false;
            this.cabliButton.Location = new System.Drawing.Point(150, 12);
            this.cabliButton.Name = "cabliButton";
            this.cabliButton.Size = new System.Drawing.Size(132, 29);
            this.cabliButton.TabIndex = 5;
            this.cabliButton.Text = "Start Calibration";
            this.cabliButton.UseVisualStyleBackColor = true;
            this.cabliButton.Click += new System.EventHandler(this.cabliButton_Click);
            // 
            // label1
            // 
            this.label1.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(955, 47);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(96, 12);
            this.label1.TabIndex = 7;
            this.label1.Text = "Camera Monitor : ";
            // 
            // textBox1
            // 
            this.textBox1.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.textBox1.BackColor = System.Drawing.SystemColors.InfoText;
            this.textBox1.ForeColor = System.Drawing.SystemColors.InactiveBorder;
            this.textBox1.HideSelection = false;
            this.textBox1.Location = new System.Drawing.Point(892, 450);
            this.textBox1.Multiline = true;
            this.textBox1.Name = "textBox1";
            this.textBox1.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.textBox1.Size = new System.Drawing.Size(305, 199);
            this.textBox1.TabIndex = 8;
            // 
            // label2
            // 
            this.label2.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(890, 435);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(49, 12);
            this.label2.TabIndex = 9;
            this.label2.Text = "Output : ";
            // 
            // chessPicture
            // 
            this.chessPicture.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.chessPicture.Image = global::ovrvision_calibration.Properties.Resources.chess4x7;
            this.chessPicture.Location = new System.Drawing.Point(12, 47);
            this.chessPicture.Name = "chessPicture";
            this.chessPicture.Size = new System.Drawing.Size(874, 602);
            this.chessPicture.SizeMode = System.Windows.Forms.PictureBoxSizeMode.CenterImage;
            this.chessPicture.TabIndex = 6;
            this.chessPicture.TabStop = false;
            // 
            // cameraPicRight
            // 
            this.cameraPicRight.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.cameraPicRight.BackColor = System.Drawing.Color.Black;
            this.cameraPicRight.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.cameraPicRight.Location = new System.Drawing.Point(957, 248);
            this.cameraPicRight.Name = "cameraPicRight";
            this.cameraPicRight.Size = new System.Drawing.Size(240, 180);
            this.cameraPicRight.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.cameraPicRight.TabIndex = 3;
            this.cameraPicRight.TabStop = false;
            this.cameraPicRight.Paint += new System.Windows.Forms.PaintEventHandler(this.cameraPicRight_Paint);
            // 
            // cameraPicLeft
            // 
            this.cameraPicLeft.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.cameraPicLeft.BackColor = System.Drawing.Color.Black;
            this.cameraPicLeft.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.cameraPicLeft.Location = new System.Drawing.Point(957, 62);
            this.cameraPicLeft.Name = "cameraPicLeft";
            this.cameraPicLeft.Size = new System.Drawing.Size(240, 180);
            this.cameraPicLeft.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.cameraPicLeft.TabIndex = 2;
            this.cameraPicLeft.TabStop = false;
            this.cameraPicLeft.Paint += new System.Windows.Forms.PaintEventHandler(this.cameraPicLeft_Paint);
            // 
            // buttonSetting
            // 
            this.buttonSetting.Enabled = false;
            this.buttonSetting.Location = new System.Drawing.Point(766, 12);
            this.buttonSetting.Name = "buttonSetting";
            this.buttonSetting.Size = new System.Drawing.Size(104, 29);
            this.buttonSetting.TabIndex = 10;
            this.buttonSetting.Text = "Camera Setting";
            this.buttonSetting.UseVisualStyleBackColor = true;
            this.buttonSetting.Click += new System.EventHandler(this.buttonSetting_Click);
            // 
            // opfCheckBox
            // 
            this.opfCheckBox.AutoSize = true;
            this.opfCheckBox.Location = new System.Drawing.Point(623, 19);
            this.opfCheckBox.Name = "opfCheckBox";
            this.opfCheckBox.Size = new System.Drawing.Size(137, 16);
            this.opfCheckBox.TabIndex = 11;
            this.opfCheckBox.Text = "Output Parameter File";
            this.opfCheckBox.UseVisualStyleBackColor = true;
            // 
            // MFrom
            // 
            this.AcceptButton = this.runbutton;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1209, 662);
            this.Controls.Add(this.opfCheckBox);
            this.Controls.Add(this.buttonSetting);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.chessPicture);
            this.Controls.Add(this.cameraPicRight);
            this.Controls.Add(this.cameraPicLeft);
            this.Controls.Add(this.cabliButton);
            this.Controls.Add(this.statelabel);
            this.Controls.Add(this.runbutton);
            this.MinimumSize = new System.Drawing.Size(1200, 700);
            this.Name = "MFrom";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Ovrvision Calibration Tool";
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.MFrom_FormClosed);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this.MFrom_KeyDown);
            ((System.ComponentModel.ISupportInitialize)(this.chessPicture)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.cameraPicRight)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.cameraPicLeft)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

		}

		#endregion

		private System.Windows.Forms.Button runbutton;
		private System.Windows.Forms.Label statelabel;
		private System.Windows.Forms.PictureBox cameraPicLeft;
        private System.Windows.Forms.PictureBox cameraPicRight;
        private System.Windows.Forms.Button cabliButton;
        private System.Windows.Forms.PictureBox chessPicture;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button buttonSetting;
        private System.Windows.Forms.CheckBox opfCheckBox;
	}
}

