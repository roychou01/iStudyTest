using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace iStudyTest.Models;

public partial class InsuranceCompany
{
    [Display(Name = "保險公司代號")]
    public string CompanyID { get; set; } = null!;

    [Display(Name = "保險公司")]
    public string? CompanyName { get; set; }

    public virtual ICollection<Product> Product { get; set; } = new List<Product>();
}
