#Copyright (c) 2015 Serguei Kouzmine
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.


# http://www.codeproject.com/Articles/42437/Toggling-the-States-of-all-CheckBoxes-Inside-a-Dat

Add-Type @"

using System;
using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Windows.Forms;

public class SelectAllGrid : Panel
{
    int TotalCheckBoxes = 0;
    int TotalCheckedCheckBoxes = 0;
    CheckBox HeaderCheckBox = null;
    bool IsHeaderCheckBoxClicked = false;
    private System.Windows.Forms.DataGridView dgvSelectAll;
    private System.Windows.Forms.DataGridViewCheckBoxColumn chkBxSelect;
    private System.Windows.Forms.DataGridViewTextBoxColumn txtBxRandomNo;
    private System.Windows.Forms.DataGridViewTextBoxColumn txtBxDate;
    private System.Windows.Forms.DataGridViewTextBoxColumn txtBxTime;
    List<Dictionary<string, object>> userData  = null ;
    public SelectAllGrid(System.Management.Automation.PSReference data = null )
    {
        var result = data.Value;
        Console.WriteLine("Result Type = {0}\n", result.GetType());
        Console.WriteLine("Result = {0}", result);
        this.dgvSelectAll = new System.Windows.Forms.DataGridView();
        this.chkBxSelect = new System.Windows.Forms.DataGridViewCheckBoxColumn();
        this.txtBxRandomNo = new System.Windows.Forms.DataGridViewTextBoxColumn();
        this.txtBxDate = new System.Windows.Forms.DataGridViewTextBoxColumn();
        this.txtBxTime = new System.Windows.Forms.DataGridViewTextBoxColumn();
        this.SuspendLayout();
        // 
        // dgvSelectAll
        // 
        this.dgvSelectAll.AllowUserToAddRows = false;
        this.dgvSelectAll.AllowUserToDeleteRows = false;
        this.dgvSelectAll.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
        this.dgvSelectAll.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.chkBxSelect,
            this.txtBxRandomNo,
            this.txtBxDate,
            this.txtBxTime});
        this.dgvSelectAll.Location = new System.Drawing.Point(12, 12);
        this.dgvSelectAll.Name = "dgvSelectAll";
        this.dgvSelectAll.Size = new System.Drawing.Size(443, 245);
        this.dgvSelectAll.TabIndex = 0;
        // 
        // chkBxSelect
        // 
        this.chkBxSelect.DataPropertyName = "IsChecked";
        this.chkBxSelect.HeaderText = "";
        this.chkBxSelect.Name = "chkBxSelect";
        this.chkBxSelect.Width = 50;
        // 
        // txtBxRandomNo
        // 
        this.txtBxRandomNo.DataPropertyName = "RandomNo";
        this.txtBxRandomNo.HeaderText = "Random No";
        this.txtBxRandomNo.Name = "txtBxRandomNo";
        this.txtBxRandomNo.ReadOnly = true;
        this.txtBxRandomNo.Width = 150;
        // 
        // txtBxDate
        // 
        this.txtBxDate.DataPropertyName = "Date";
        this.txtBxDate.HeaderText = "Date";
        this.txtBxDate.Name = "txtBxDate";
        this.txtBxDate.ReadOnly = true;
        // 
        // txtBxTime
        // 
        this.txtBxTime.DataPropertyName = "url";
        this.txtBxTime.HeaderText = "url";
        this.txtBxTime.Name = "txtBxTime";
        this.txtBxTime.ReadOnly = true;
        // 
        // GridSelectAll
        // 

        this.ClientSize = new System.Drawing.Size(469, 267);
        this.Controls.Add(this.dgvSelectAll);
        this.Name = "frmSelectAll";
        this.Text = "Select All Demo";
        // https://msdn.microsoft.com/en-us/library/system.windows.forms.panel_events%28v=vs.110%29.aspx
        AddHeaderCheckBox();

        HeaderCheckBox.KeyUp += new KeyEventHandler(HeaderCheckBox_KeyUp);
        HeaderCheckBox.MouseClick += new MouseEventHandler(HeaderCheckBox_MouseClick);
        dgvSelectAll.CellValueChanged += new DataGridViewCellEventHandler(dgvSelectAll_CellValueChanged);
        dgvSelectAll.CurrentCellDirtyStateChanged += new EventHandler(dgvSelectAll_CurrentCellDirtyStateChanged);
        dgvSelectAll.CellPainting += new DataGridViewCellPaintingEventHandler(dgvSelectAll_CellPainting);

        dgvSelectAll.DataSource = GetDataSource(userData );
        TotalCheckBoxes = dgvSelectAll.RowCount;
        TotalCheckedCheckBoxes = 0;

        this.ResumeLayout(false);

    }
    // http://www.codeproject.com/Articles/20733/How-to-Populate-a-DataGridView-Control-using-OleDb

    public DataTable GetDataSource(List<Dictionary<string, object>> userData = null  ){
        DataTable dTable = new DataTable();

        DataRow dRow = null;
         List<Dictionary<string, object>> sampleData ;
        if (userData == null) {


        Random rnd = new Random();
        sampleData = new List<Dictionary<string, object>> {

   new Dictionary<string, object> { { "RandomNo", rnd.NextDouble()}, { "Date", DateTime.Now.ToString("MM/dd/yyyy") }, { "url", "www.facebook.com"}} ,
   new Dictionary<string, object> { { "RandomNo", rnd.NextDouble()}, { "Date", DateTime.Now.ToString("MM/dd/yyyy") }, { "url", "www.linkedin.com"}} ,
   new Dictionary<string, object> { { "RandomNo", rnd.NextDouble()}, { "Date", DateTime.Now.ToString("MM/dd/yyyy") }, { "url", "www.odesk.com"}}  
};
} else {
sampleData = userData  ;
}
        Dictionary<string, object> openWith = sampleData[0];

        Dictionary<string, object>.KeyCollection keyColl = openWith.Keys;

        dTable.Columns.Add("IsChecked", System.Type.GetType("System.Boolean"));
        foreach (string s in keyColl)
        {
            dTable.Columns.Add(s);
        }

        foreach (Dictionary<string, object> objitem in sampleData)
        {
            dRow = dTable.NewRow();
            foreach (KeyValuePair<string, object> kvp in objitem)
            {
                dRow[kvp.Key] = kvp.Value.ToString();
            }
            dTable.Rows.Add(dRow);
            dTable.AcceptChanges();

        }

        return dTable;

    }
    public  DataTable GetDataSource()
    {
        DataTable dTable = new DataTable();

        DataRow dRow = null;
        DateTime dTime;
        Random rnd = new Random();

        List<Dictionary<string, object>> sampleData = new List<Dictionary<string, object>> {

   new Dictionary<string, object> { { "RandomNo", rnd.NextDouble()}, { "Date", DateTime.Now.ToString("MM/dd/yyyy") }, { "url", "www.facebook.com"}} ,
   new Dictionary<string, object> { { "RandomNo", rnd.NextDouble()}, { "Date", DateTime.Now.ToString("MM/dd/yyyy") }, { "url", "www.linkedin.com"}} ,
   new Dictionary<string, object> { { "RandomNo", rnd.NextDouble()}, { "Date", DateTime.Now.ToString("MM/dd/yyyy") }, { "url", "www.odesk.com"}}  
};


        Dictionary<string, object> openWith = sampleData[0];

        Dictionary<string, object>.KeyCollection keyColl = openWith.Keys;

        dTable.Columns.Add("IsChecked", System.Type.GetType("System.Boolean"));
        foreach (string s in keyColl)
        {
            dTable.Columns.Add(s);
            // Console.WriteLine("Key = {0}", s);
        }

        foreach (Dictionary<string, object> objitem in sampleData)
        {
            dRow = dTable.NewRow();
            dTime = DateTime.Now;
            foreach (KeyValuePair<string, object> kvp in objitem)
            {
                dRow[kvp.Key] = kvp.Value.ToString();
                // Console.WriteLine("Key = {0}, Value = {1}", kvp.Key, kvp.Value);
            }
            dTable.Rows.Add(dRow);
            dTable.AcceptChanges();

        }

        /*
        for (int n = 0; n < 10; ++n)
        {
            dRow = dTable.NewRow();
            dTime = DateTime.Now;

            dRow["IsChecked"] = "false";
            dRow["RandomNo"] = rnd.NextDouble();
            dRow["Date"] = dTime.ToString("MM/dd/yyyy");
            dRow["url"] = dTime.ToString("hh:mm:ss tt");

            dTable.Rows.Add(dRow);
            dTable.AcceptChanges();
        }
*/
        return dTable;
    }

    private void dgvSelectAll_CellValueChanged(object sender, DataGridViewCellEventArgs e)
    {
        if (!IsHeaderCheckBoxClicked)
            RowCheckBoxClick((DataGridViewCheckBoxCell)dgvSelectAll[e.ColumnIndex, e.RowIndex]);
    }

    private void dgvSelectAll_CurrentCellDirtyStateChanged(object sender, EventArgs e)
    {
        if (dgvSelectAll.CurrentCell is DataGridViewCheckBoxCell)
            dgvSelectAll.CommitEdit(DataGridViewDataErrorContexts.Commit);
    }

    private void HeaderCheckBox_MouseClick(object sender, MouseEventArgs e)
    {
        HeaderCheckBoxClick((CheckBox)sender);
    }

    private void HeaderCheckBox_KeyUp(object sender, KeyEventArgs e)
    {
        if (e.KeyCode == Keys.Space)
            HeaderCheckBoxClick((CheckBox)sender);
    }

    private void dgvSelectAll_CellPainting(object sender, DataGridViewCellPaintingEventArgs e)
    {
        if (e.RowIndex == -1 && e.ColumnIndex == 0)
            ResetHeaderCheckBoxLocation(e.ColumnIndex, e.RowIndex);
    }

    private void AddHeaderCheckBox()
    {
        HeaderCheckBox = new CheckBox();

        HeaderCheckBox.Size = new Size(15, 15);

        //Add the CheckBox into the DataGridView
        this.dgvSelectAll.Controls.Add(HeaderCheckBox);
    }

    private void ResetHeaderCheckBoxLocation(int ColumnIndex, int RowIndex)
    {
        //Get the column header cell bounds
        Rectangle oRectangle = this.dgvSelectAll.GetCellDisplayRectangle(ColumnIndex, RowIndex, true);

        Point oPoint = new Point();

        oPoint.X = oRectangle.Location.X + (oRectangle.Width - HeaderCheckBox.Width) / 2 + 1;
        oPoint.Y = oRectangle.Location.Y + (oRectangle.Height - HeaderCheckBox.Height) / 2 + 1;

        //Change the location of the CheckBox to make it stay on the header
        HeaderCheckBox.Location = oPoint;
    }

    private void HeaderCheckBoxClick(CheckBox HCheckBox)
    {
        IsHeaderCheckBoxClicked = true;

        foreach (DataGridViewRow Row in dgvSelectAll.Rows)
            ((DataGridViewCheckBoxCell)Row.Cells["chkBxSelect"]).Value = HCheckBox.Checked;

        dgvSelectAll.RefreshEdit();

        TotalCheckedCheckBoxes = HCheckBox.Checked ? TotalCheckBoxes : 0;

        IsHeaderCheckBoxClicked = false;
    }
private void RowCheckBoxClick(DataGridViewCheckBoxCell RCheckBox)
    {
        if (RCheckBox != null)
        {
            //Modifiy Counter;            
            if ((bool)RCheckBox.Value && TotalCheckedCheckBoxes < TotalCheckBoxes)
                TotalCheckedCheckBoxes++;
            else if (TotalCheckedCheckBoxes > 0)
                TotalCheckedCheckBoxes--;

            //Change state of the header CheckBox.
            if (TotalCheckedCheckBoxes < TotalCheckBoxes)
                HeaderCheckBox.Checked = false;
            else if (TotalCheckedCheckBoxes == TotalCheckBoxes)
                HeaderCheckBox.Checked = true;
        }
    }
}


"@ -ReferencedAssemblies 'System.Windows.Forms.dll','System.Drawing.dll','System.Data.dll','System.Xml.dll'


function SelectAllGrid {

  param(
    [string]$title,
    [string]$message
  )


  @( 'System.Drawing','System.Windows.Forms') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }
  $f = New-Object System.Windows.Forms.Form
  $f.Text = $title

  $f.Size = New-Object System.Drawing.Size (470,235)
  $f.AutoScaleDimensions = New-Object System.Drawing.SizeF(6.0, 13.0)
  $f.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Font
  $f.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedToolWindow
  $f.StartPosition = 'CenterScreen'


# https://groups.google.com/forum/#!topic/microsoft.public.windows.powershell/Ta9NyFPovgI 
$array = New-Object 'System.Collections.Generic.List[System.Collections.Generic.Dictionary[String,Object]]'
for ($cnt = 0 ; $cnt -ne 10  ; $cnt ++  ) {
$item = New-Object 'System.Collections.Generic.Dictionary[String,Object]'
$item.Add('RandomNo', $cnt) 
$item.Add('date', ( Date )) 
$item.Add('url',  'http://www.google.com/' ) 
$array.add($item)
}
$array.GetType()
$array_ref = [ref]$array
$array_ref
$null_value = $null 
$null_ref = [ref]$null_value 
$r = New-Object -TypeName 'SelectAllGrid' -ArgumentList $null_ref 
# [System.Collections.Generic.List[System.Collections.Generic.Dictionary[String,Object]]]
# New-Object : Argument: '1' should not be a System.Management.Automation.PSReference. Do not use [ref].

#   $r = New-Object -TypeName 'SelectAllGrid' -ArgumentList $array_ref
  $r.Size = $f.Size

  $f.Controls.Add($r)
  $f.Topmost = $True

  $f.Add_Shown({ $f.Activate() })

  [void]$f.ShowDialog()
  $f.Dispose()
}
$script:Data = $null
SelectAllGrid -Title 'Selection Grid Sample Project'
Write-Output $script:Data

# Microsoft GIF Animator
