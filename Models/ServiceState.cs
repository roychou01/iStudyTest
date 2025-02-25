using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace iStudyTest.Models;

public partial class ServiceState
{
    [Display(Name = "狀態碼")]
    public string StateCode { get; set; } = null!;

    [Display(Name = "狀態")]
    public string State { get; set; } = null!;

    public virtual ICollection<ServiceList> ServiceList { get; set; } = new List<ServiceList>();
}
