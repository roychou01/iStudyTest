using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace iStudyTest.Models;

public partial class EmployeeRoles
{
    [Display(Name = "員工權限碼")]
    public string RoleCode { get; set; } = null!;

    [Display(Name = "員工權限")]
    public string Role { get; set; } = null!;

    public virtual ICollection<Employee> Employee { get; set; } = new List<Employee>();
}
