using System;
using System.Collections.Generic;

namespace iStudyTest.Models;

public partial class Insurance
{
    public string PolicyNumber { get; set; } = null!;

    public string Insurer { get; set; } = null!;

    public string Insured { get; set; } = null!;

    public DateOnly Orderdate { get; set; }

    public DateOnly? EffectiveDate { get; set; }

    public string? PaymentMethod { get; set; }

    public DateOnly? ExpiryDate { get; set; }

    public string ProductNumber { get; set; } = null!;

    public string ServiceNumber { get; set; } = null!;

    public decimal Amount { get; set; }

    public virtual Product? ProductNumberNavigation { get; set; } 

    public virtual ServiceList? ServiceNumberNavigation { get; set; } 
}
