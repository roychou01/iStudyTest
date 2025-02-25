using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace iStudyTest.Models;

public partial class SpendType
{
    public string TypeCode { get; set; } = null!;

    [Display(Name = "收支類別")]
    public string Type { get; set; } = null!;

    public virtual ICollection<SpendItem> SpendItem { get; set; } = new List<SpendItem>();
}
