using System;
using System.Collections.Generic;

namespace iStudyTest.Models;

public partial class Product
{
    public string ProductNumber { get; set; } = null!;

    public string ProductName { get; set; } = null!;

    public DateOnly? LaunchDate { get; set; }

    public DateOnly? DiscontinuedDate { get; set; }

    public int? ValidityPeriod { get; set; }

    public string? Type { get; set; }

    public string CompanyID { get; set; } = null!;

    public string? DM { get; set; }

    public string? DMType { get; set; }

    public string? Feature { get; set; }

    public virtual InsuranceCompany? Company { get; set; } 

    public virtual ICollection<Insurance> Insurance { get; set; } = new List<Insurance>();
}
