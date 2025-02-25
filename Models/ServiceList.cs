using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace iStudyTest.Models;

public partial class ServiceList
{
    [Display(Name = "服務單號")]
    public string ServiceNumber { get; set; } = null!;

    [Display(Name = "建立日期")]
    [DisplayFormat(DataFormatString = "{0:yyyy/MM/dd}", ApplyFormatInEditMode = true)]
    public DateTime CreateDate { get; set; }

    [Display(Name = "會員編號")]
    public string MemberID { get; set; } = null!;

    [Display(Name = "業務歸屬")]
    public string? CurrentBusiness { get; set; } 

    [Display(Name = "狀態碼")]
    public string StateCode { get; set; } = null!;

    //public virtual Employee CurrentBusinessNavigation { get; set; } = null!; 
      //250221 初建時尚未配予服務人員，故允許空值，可待成交後再指派

    public virtual ICollection<Insurance> Insurance { get; set; } = new List<Insurance>();

    public virtual Member Member { get; set; } = null!;

    public virtual ICollection<ServiceDetail> ServiceDetail { get; set; } = new List<ServiceDetail>();

    public virtual ServiceState StateCodeNavigation { get; set; } = null!;
}
