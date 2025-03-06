using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace iStudyTest.Models;

public partial class SpendItem
{
    [Display(Name = "收支項目代碼")]
    public string ItemCode { get; set; } = null!;

    [Display(Name = "收支項目名稱")]
    public string Item { get; set; } = null!;

    [Display(Name = "類別代碼")]
    public string TypeCode { get; set; } = null!;

    public virtual ICollection<IncomeAndSpendDetail> IncomeAndSpendDetail { get; set; } = new List<IncomeAndSpendDetail>();

    public virtual SpendType? TypeCodeNavigation { get; set; } 
}
