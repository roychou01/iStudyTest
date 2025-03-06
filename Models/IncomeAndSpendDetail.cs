using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace iStudyTest.Models;

public partial class IncomeAndSpendDetail
{
    [Display(Name = "收支簿編號")]
    public string SpendNumber { get; set; } = null!;

    [Display(Name = "項目代碼")]
    public string ItemCode { get; set; } = null!;

    [Display(Name = "金額")]
    [DisplayFormat(DataFormatString = "{0:C0}", ApplyFormatInEditMode = true)]
    public decimal? Amount { get; set; }

    public virtual SpendItem? ItemCodeNavigation { get; set; } 

    public virtual IncomeAndSpend? SpendNumberNavigation { get; set; } 
}
