using System;
using System.Collections.Generic;

namespace iStudyTest.Models;

public partial class SpendType
{
    public string TypeCode { get; set; } = null!;

    public string Type { get; set; } = null!;

    public virtual ICollection<SpendItem> SpendItem { get; set; } = new List<SpendItem>();
}
