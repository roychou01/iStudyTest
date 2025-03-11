using System;
using System.Collections.Generic;

namespace iStudyTest.Models;

public partial class IncomeAndSpendDetail
{
    public string SpendNumber { get; set; } = null!;

    public string ItemCode { get; set; } = null!;

    public decimal? Amount { get; set; }

    public virtual SpendItem? ItemCodeNavigation { get; set; } 

    public virtual IncomeAndSpend? SpendNumberNavigation { get; set; } 
}
