using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace iStudyTest.Models;

public partial class iStudyTestContext : DbContext
{
    public iStudyTestContext(DbContextOptions<iStudyTestContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Employee> Employee { get; set; }

    public virtual DbSet<EmployeeRoles> EmployeeRoles { get; set; }

    public virtual DbSet<IncomeAndSpend> IncomeAndSpend { get; set; }

    public virtual DbSet<IncomeAndSpendDetail> IncomeAndSpendDetail { get; set; }

    public virtual DbSet<Insurance> Insurance { get; set; }

    public virtual DbSet<InsuranceCompany> InsuranceCompany { get; set; }

    public virtual DbSet<Member> Member { get; set; }

    public virtual DbSet<Product> Product { get; set; }

    public virtual DbSet<ServiceDetail> ServiceDetail { get; set; }

    public virtual DbSet<ServiceList> ServiceList { get; set; }

    public virtual DbSet<ServiceState> ServiceState { get; set; }

    public virtual DbSet<SpendItem> SpendItem { get; set; }

    public virtual DbSet<SpendType> SpendType { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Employee>(entity =>
        {
            entity.HasKey(e => e.EmployeeID).HasName("PK__Employee__7AD04FF11799D602");

            entity.HasIndex(e => e.PersonalID, "UQ__Employee__28343712ABECF4C6").IsUnique();

            entity.Property(e => e.EmployeeID)
                .HasMaxLength(7)
                .IsUnicode(false)
                .HasDefaultValueSql("([dbo].[GetEmployeeID]())")
                .IsFixedLength();
            entity.Property(e => e.Address).HasMaxLength(50);
            entity.Property(e => e.EmployeePhoto).HasMaxLength(20);
            entity.Property(e => e.Experience).HasMaxLength(200);
            entity.Property(e => e.Gender)
                .HasMaxLength(5)
                .IsFixedLength();
            entity.Property(e => e.JobTitle).HasMaxLength(20);
            entity.Property(e => e.Name).HasMaxLength(27);
            entity.Property(e => e.Password).HasMaxLength(64);
            entity.Property(e => e.PersonalID)
                .HasMaxLength(10)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.Phone).HasMaxLength(15);
            entity.Property(e => e.RoleCode)
                .HasMaxLength(6)
                .IsFixedLength();

            entity.HasOne(d => d.RoleCodeNavigation).WithMany(p => p.Employee)
                .HasForeignKey(d => d.RoleCode)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Employee__RoleCo__571DF1D5");
        });

        modelBuilder.Entity<EmployeeRoles>(entity =>
        {
            entity.HasKey(e => e.RoleCode).HasName("PK__Employee__D62CB59DDD54D002");

            entity.Property(e => e.RoleCode)
                .HasMaxLength(6)
                .IsFixedLength();
            entity.Property(e => e.Role).HasMaxLength(10);
        });

        modelBuilder.Entity<IncomeAndSpend>(entity =>
        {
            entity.HasKey(e => e.SpendNumber).HasName("PK__IncomeAn__2B6894B706F0F23D");

            entity.Property(e => e.SpendNumber)
                .HasMaxLength(20)
                .IsFixedLength();
            entity.Property(e => e.MemberID)
                .HasMaxLength(6)
                .IsFixedLength();

            entity.HasOne(d => d.Member).WithMany(p => p.IncomeAndSpend)
                .HasForeignKey(d => d.MemberID)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__IncomeAnd__Membe__5812160E");
        });

        modelBuilder.Entity<IncomeAndSpendDetail>(entity =>
        {
            entity.HasKey(e => new { e.SpendNumber, e.ItemCode }).HasName("PK__IncomeAn__88845449C4617C62");

            entity.Property(e => e.SpendNumber)
                .HasMaxLength(20)
                .IsFixedLength();
            entity.Property(e => e.ItemCode)
                .HasMaxLength(2)
                .IsFixedLength();
            entity.Property(e => e.Amount)
                .HasDefaultValue(0m)
                .HasColumnType("money");

            entity.HasOne(d => d.ItemCodeNavigation).WithMany(p => p.IncomeAndSpendDetail)
                .HasForeignKey(d => d.ItemCode)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__IncomeAnd__ItemC__59063A47");

            entity.HasOne(d => d.SpendNumberNavigation).WithMany(p => p.IncomeAndSpendDetail)
                .HasForeignKey(d => d.SpendNumber)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__IncomeAnd__Spend__59FA5E80");
        });

        modelBuilder.Entity<Insurance>(entity =>
        {
            entity.HasKey(e => e.PolicyNumber).HasName("PK__Insuranc__46DA015609BE8987");

            entity.Property(e => e.PolicyNumber).HasMaxLength(20);
            entity.Property(e => e.Amount).HasColumnType("money");
            entity.Property(e => e.Insured).HasMaxLength(27);
            entity.Property(e => e.Insurer).HasMaxLength(27);
            entity.Property(e => e.PaymentMethod).HasMaxLength(20);
            entity.Property(e => e.ProductNumber).HasMaxLength(10);
            entity.Property(e => e.ServiceNumber)
                .HasMaxLength(11)
                .IsUnicode(false)
                .IsFixedLength();

            entity.HasOne(d => d.ProductNumberNavigation).WithMany(p => p.Insurance)
                .HasForeignKey(d => d.ProductNumber)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Insurance__Produ__628FA481");

            entity.HasOne(d => d.ServiceNumberNavigation).WithMany(p => p.Insurance)
                .HasForeignKey(d => d.ServiceNumber)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Insurance__Servi__6383C8BA");
        });

        modelBuilder.Entity<InsuranceCompany>(entity =>
        {
            entity.HasKey(e => e.CompanyID).HasName("PK__Insuranc__2D971C4C657F7D7F");

            entity.Property(e => e.CompanyID).HasMaxLength(10);
            entity.Property(e => e.CompanyName).HasMaxLength(50);
        });

        modelBuilder.Entity<Member>(entity =>
        {
            entity.HasKey(e => e.MemberID).HasName("PK__Member__0CF04B3838D80D78");

            entity.HasIndex(e => e.Email, "UQ__Member__A9D105346D013126").IsUnique();

            entity.Property(e => e.MemberID)
                .HasMaxLength(6)
                .HasDefaultValueSql("([dbo].[fnGetNewMemberID]())")
                .IsFixedLength();
            entity.Property(e => e.Address).HasMaxLength(50);
            entity.Property(e => e.Email).HasMaxLength(20);
            entity.Property(e => e.Gender)
                .HasMaxLength(5)
                .IsFixedLength();
            entity.Property(e => e.Name).HasMaxLength(27);
            entity.Property(e => e.Password).HasMaxLength(64);
            entity.Property(e => e.phone)
                .HasMaxLength(15)
                .IsFixedLength();
        });

        modelBuilder.Entity<Product>(entity =>
        {
            entity.HasKey(e => e.ProductNumber).HasName("PK__Product__49A3C838E78FCD08");

            entity.Property(e => e.ProductNumber).HasMaxLength(10);
            entity.Property(e => e.CompanyID).HasMaxLength(10);
            entity.Property(e => e.DM).HasMaxLength(20);
            entity.Property(e => e.DMType).HasMaxLength(10);
            entity.Property(e => e.ProductName).HasMaxLength(30);
            entity.Property(e => e.Type).HasMaxLength(10);

            entity.HasOne(d => d.Company).WithMany(p => p.Product)
                .HasForeignKey(d => d.CompanyID)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Product__Company__5DCAEF64");
        });

        modelBuilder.Entity<ServiceDetail>(entity =>
        {
            entity.HasKey(e => new { e.ServiceNumber, e.EmployeeID }).HasName("PK__ServiceD__BF503E896E1D5708");

            entity.Property(e => e.ServiceNumber)
                .HasMaxLength(11)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.EmployeeID)
                .HasMaxLength(7)
                .IsUnicode(false)
                .IsFixedLength();
            entity.Property(e => e.ServiceDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.HasOne(d => d.Employee).WithMany(p => p.ServiceDetail)
                .HasForeignKey(d => d.EmployeeID)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ServiceDe__Emplo__5EBF139D");

            entity.HasOne(d => d.ServiceNumberNavigation).WithMany(p => p.ServiceDetail)
                .HasForeignKey(d => d.ServiceNumber)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ServiceDe__Servi__5FB337D6");
        });

        modelBuilder.Entity<ServiceList>(entity =>
        {
            entity.HasKey(e => e.ServiceNumber).HasName("PK__ServiceL__B8FD3A76D63CB6AB");

            entity.Property(e => e.ServiceNumber)
                .HasMaxLength(11)
                .IsUnicode(false)
                .HasDefaultValueSql("([dbo].[GetServiceID]())")
                .IsFixedLength();
            entity.Property(e => e.CreateDate)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.CurrentBusiness)
                .HasMaxLength(7)
                .IsFixedLength();
            entity.Property(e => e.MemberID)
                .HasMaxLength(6)
                .IsFixedLength();
            entity.Property(e => e.StateCode)
                .HasMaxLength(2)
                .IsFixedLength();

            entity.HasOne(d => d.Member).WithMany(p => p.ServiceList)
                .HasForeignKey(d => d.MemberID)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ServiceLi__Membe__619B8048");

            entity.HasOne(d => d.StateCodeNavigation).WithMany(p => p.ServiceList)
                .HasForeignKey(d => d.StateCode)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__ServiceLi__State__628FA481");
        });

        modelBuilder.Entity<ServiceState>(entity =>
        {
            entity.HasKey(e => e.StateCode).HasName("PK__ServiceS__D515E98B2107CA54");

            entity.Property(e => e.StateCode)
                .HasMaxLength(2)
                .IsFixedLength();
            entity.Property(e => e.State).HasMaxLength(10);
        });

        modelBuilder.Entity<SpendItem>(entity =>
        {
            entity.HasKey(e => e.ItemCode).HasName("PK__SpendIte__3ECC0FEBB3AFCC9F");

            entity.Property(e => e.ItemCode)
                .HasMaxLength(2)
                .IsFixedLength();
            entity.Property(e => e.Item).HasMaxLength(20);
            entity.Property(e => e.TypeCode)
                .HasMaxLength(3)
                .IsFixedLength();

            entity.HasOne(d => d.TypeCodeNavigation).WithMany(p => p.SpendItem)
                .HasForeignKey(d => d.TypeCode)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__SpendItem__TypeC__6383C8BA");
        });

        modelBuilder.Entity<SpendType>(entity =>
        {
            entity.HasKey(e => e.TypeCode).HasName("PK__SpendTyp__3E1CDC7D2057D983");

            entity.Property(e => e.TypeCode)
                .HasMaxLength(3)
                .IsFixedLength();
            entity.Property(e => e.Type).HasMaxLength(10);
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
