using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace iStudyTest.Models;

public class MemberData
{
    [Display(Name = "會員編號")]
    [StringLength(6, MinimumLength = 6)]
    public string MemberID { get; set; } = null!;

    [Display(Name = "會員姓名")]
    public string Name { get; set; } = null!;

    [Display(Name = "生日")]
    [DataType(DataType.Date)]
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

    [Display(Name = "密碼", Prompt = "密碼為8-16碼")]
    [Required(ErrorMessage = "必填")]
    [StringLength(16, MinimumLength = 8, ErrorMessage = "密碼為8-16碼")]
    [MinLength(8)]
    [MaxLength(16)]
    [DataType(DataType.Password)]
    public string Password { get; set; } = null!;
}
[ModelMetadataType(typeof(MemberData))]
public partial class Member
{
    [NotMapped]  //這項要在DB first重建後再加
    [Display(Name = "再填一次密碼", Prompt = "密碼為8-16碼")]
    [Required(ErrorMessage = "必填")]
    [Compare(nameof(Password), ErrorMessage = "密碼兩次輸入不相同")]
    [DataType(DataType.Password)]
    public string PasswordConfirm { get; set; } = null!;
}





