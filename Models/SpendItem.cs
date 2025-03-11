using System;
using System.Collections.Generic;

namespace iStudyTest.Models;

public partial class SpendItem
{
    public string ItemCode { get; set; } = null!;

    public string Item { get; set; } = null!;

    public string TypeCode { get; set; } = null!;

    public virtual ICollection<IncomeAndSpendDetail> IncomeAndSpendDetail { get; set; } = new List<IncomeAndSpendDetail>();

    public virtual SpendType? TypeCodeNavigation { get; set; } 
}
