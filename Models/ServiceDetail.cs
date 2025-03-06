using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace iStudyTest.Models;

public partial class ServiceDetail
{
    [Display(Name = "服務單號")]
    public string ServiceNumber { get; set; } = null!;

    [Display(Name = "服務人員工號")]
    public string EmployeeID { get; set; } = null!;

    [Display(Name = "服務日期")]
    [DisplayFormat(DataFormatString = "{0:yyyy/MM/dd}", ApplyFormatInEditMode = true)]
    public DateTime? ServiceDate { get; set; }

    public virtual Employee? Employee { get; set; } 

    public virtual ServiceList? ServiceNumberNavigation { get; set; } 
}
