using System;
using System.Collections.Generic;

namespace iStudyTest.Models;

public partial class IncomeAndSpend
{
    public string SpendNumber { get; set; } = null!;

    public string MemberID { get; set; } = null!;

    public virtual ICollection<IncomeAndSpendDetail> IncomeAndSpendDetail { get; set; } = new List<IncomeAndSpendDetail>();

    public virtual Member? Member { get; set; } 
}
