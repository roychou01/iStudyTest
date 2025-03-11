using System;
using System.Collections.Generic;

namespace iStudyTest.Models;

public partial class Member
{
    public string MemberID { get; set; } = null!;

    public string Name { get; set; } = null!;

    public DateOnly Birthday { get; set; }

    public string Address { get; set; } = null!;

    public string Gender { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string phone { get; set; } = null!;

    public string Password { get; set; } = null!;

    public virtual ICollection<IncomeAndSpend> IncomeAndSpend { get; set; } = new List<IncomeAndSpend>();

    public virtual ICollection<ServiceList> ServiceList { get; set; } = new List<ServiceList>();
}
