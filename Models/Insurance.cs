using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace iStudyTest.Models;

public partial class Insurance
{
    [Display(Name = "保單編號")]
    public string PolicyNumber { get; set; } = null!;

    [Display(Name = "投保人")]
    public string Insurer { get; set; } = null!;

    [Display(Name = "被保險人")]
    public string Insured { get; set; } = null!;

    [Display(Name = "要保日")]
    [DataType(DataType.Date)]
    public DateTime Orderdate { get; set; }

    [Display(Name = "生效日")]
    [DataType(DataType.Date)]
    public DateTime? EffectiveDate { get; set; }

    [Display(Name = "付款方式")]
    public string? PaymentMethod { get; set; }

    [Display(Name = "有效期限")]
    [DataType(DataType.Date)]
    public DateTime? ExpiryDate { get; set; }

    [Display(Name = "產品編號")]
    public string ProductNumber { get; set; } = null!;

    [Display(Name = "服務單號")]
    public string ServiceNumber { get; set; } = null!;

    [Display(Name = "保單金額")]
    [DisplayFormat(DataFormatString = "{0:C0}", ApplyFormatInEditMode = true)]
    public decimal Amount { get; set; }

    public virtual Product? ProductNumberNavigation { get; set; } 

    public virtual ServiceList? ServiceNumberNavigation { get; set; }
}
