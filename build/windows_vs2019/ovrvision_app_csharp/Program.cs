﻿using System;
using System.Collections.Generic;
using System.Windows.Forms;

namespace ovrvision_app
{
	static class Program
	{
		[STAThread]
		static void Main()
		{
			Application.EnableVisualStyles();
			Application.SetCompatibleTextRenderingDefault(false);
			Application.Run(new MFrom());
		}
	}
}
