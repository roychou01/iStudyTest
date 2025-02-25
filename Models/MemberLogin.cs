using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace iStudyTest.Models;

public partial class MemberLogin
{
    [Display(Name = "電子郵件")]
    public string Email { get; set; } = null!;

    [Display(Name = "會員密碼")]
    public string Password { get; set; } = null!;

    public virtual Member EmailNavigation { get; set; } = null!;
}
