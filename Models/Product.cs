using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace iStudyTest.Models;

public partial class Product
{
    [Display(Name = "產品編號")]
    [StringLength(10, MinimumLength = 3, ErrorMessage = "編號 3~10字")]
    [Required(ErrorMessage = "必填")]
    public string ProductNumber { get; set; } = null!;

    [Display(Name = "產品名稱")]
    [StringLength(30, MinimumLength = 1, ErrorMessage = "名稱 1~30字")]
    [Required(ErrorMessage = "必填")]
    public string ProductName { get; set; } = null!;

    [Display(Name = "上架日")]
    [DataType(DataType.Date)]
    public DateTime LaunchDate { get; set; }

    [Display(Name = "停售日")]
    [DataType(DataType.Date)]
    public DateTime? DiscontinuedDate { get; set; }

    [Display(Name = "效期(月)")]
    public int? ValidityPeriod { get; set; }

    [Display(Name = "類型")]
    public string? Type { get; set; }

    [Display(Name = "保險公司編號")]
    public string CompanyID { get; set; } = null!;

    [Display(Name = "產品圖")]
    public string? DM { get; set; }

    [Display(Name = "圖檔類型")]
    public string? DMType { get; set; }

    [Display(Name = "產品特色")]
    [DataType(DataType.MultilineText)]  //顯示多行文字方塊
    public string? Feature { get; set; }

    public virtual InsuranceCompany? Company { get; set; }

    public virtual ICollection<Insurance> Insurance { get; set; } = new List<Insurance>();
}
