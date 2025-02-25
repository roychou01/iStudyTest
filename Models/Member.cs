using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace iStudyTest.Models;

public partial class Member
{
    [Display(Name = "會員編號")]
    [StringLength(6, MinimumLength = 6)]
    public string MemberID { get; set; } = null!;

    [Display(Name = "會員姓名")]
    public string Name { get; set; } = null!;

    [Display(Name = "生日")]
    [DisplayFormat(DataFormatString = "{0:yyyy/MM/dd}", ApplyFormatInEditMode = true)]
    public DateTime Birthday { get; set; }

    [Display(Name = "地址")]
    [DataType(DataType.MultilineText)]
    public string Address { get; set; } = null!;

    [Display(Name = "性別")]
    public string Gender { get; set; } = null!;

    [Display(Name = "電子郵件")]
    public string Email { get; set; } = null!;

    [Display(Name = "手機號碼")]
    public string phone { get; set; } = null!;


    public virtual ICollection<IncomeAndSpend> IncomeAndSpend { get; set; } = new List<IncomeAndSpend>();

    public virtual MemberLogin? MemberLogin { get; set; }

    public virtual ICollection<ServiceList> ServiceList { get; set; } = new List<ServiceList>();
}
