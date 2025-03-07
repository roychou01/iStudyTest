using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace iStudyTest.Models;

public partial class MemberLogin
{
    [Display(Name = "電子郵件")]
    [Required(ErrorMessage = "必填")]
    public string Email { get; set; } = null!;

    [Display(Name = "會員密碼")]
    [Required(ErrorMessage = "必填")]
    [StringLength(16, MinimumLength = 8, ErrorMessage = "密碼為8-16碼")]
    [MinLength(8)]
    [MaxLength(16)]
    [DataType(DataType.Password)]
    public string Password { get; set; } = null!;

    public virtual Member EmailNavigation { get; set; } = null!;
}
