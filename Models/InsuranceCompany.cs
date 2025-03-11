using System;
using System.Collections.Generic;

namespace iStudyTest.Models;

public partial class InsuranceCompany
{
    public string CompanyID { get; set; } = null!;

    public string? CompanyName { get; set; }

    public virtual ICollection<Product> Product { get; set; } = new List<Product>();
}
