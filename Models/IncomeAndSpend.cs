using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace iStudyTest.Models;

public partial class IncomeAndSpend
{
    [Display(Name = "收支簿編號")]
    public string SpendNumber { get; set; } = null!;

    [Display(Name = "會員編號")]
    public string MemberID { get; set; } = null!;

    public virtual ICollection<IncomeAndSpendDetail> IncomeAndSpendDetail { get; set; } = new List<IncomeAndSpendDetail>();

    public virtual Member Member { get; set; } = null!;
}
