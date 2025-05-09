﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using iStudyTest.Models;
using NuGet.Protocol;
using iStudyTest.Filters;

namespace iStudyTest.Controllers
{
    
    public class EmployeeController : Controller
    {
        private readonly iStudyTestContext _context;

        public EmployeeController(iStudyTestContext context)
        {
            _context = context;
        }

        // GET: Employee
        [ServiceFilter(typeof(EmpLoginStFilter))]
        public async Task<IActionResult> Index()
        {
            var iStudyTestContext = _context.Employee.Include(e => e.RoleCodeNavigation);
            return View(await iStudyTestContext.ToListAsync());
        }

        
        public IActionResult Login()
        {
            return View();
        }

        [HttpPost]

        public async Task<IActionResult> Login(Employee employee)
        {
            var result = await _context.Employee.Where(m => m.EmployeeID == employee.EmployeeID && m.Password == _context.ComputeSha256Hash(employee.Password)).FirstOrDefaultAsync();

            //如果帳密正確,導入後台頁面
            if (result != null)
            {
                //發給證明,證明他已經登入
                HttpContext.Session.SetString("EmployeeInfo", result.ToJson());

                return RedirectToAction("Index", "ManageProducts");
            }
            else //如果帳密不正確,回到登入頁面,並告知帳密錯誤
            {
                ViewData["Message"] = "帳號或密碼錯誤";
            }

            return View(result);
        }
        public IActionResult Logout()
        {
            //5.4.2 在Logout Action中清除Session
            HttpContext.Session.Remove("EmployeeInfo");//清掉
            return RedirectToAction("Index", "Home");
        }


            // GET: Employee/Details/5
            public async Task<IActionResult> Details(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var employee = await _context.Employee
                .Include(e => e.RoleCodeNavigation)
                .FirstOrDefaultAsync(m => m.EmployeeID == id);
            if (employee == null)
            {
                return NotFound();
            }

            return View(employee);
        }

        // GET: Employee/Create
        public IActionResult Create()
        {
            ViewData["RoleCode"] = new SelectList(_context.EmployeeRoles, "RoleCode", "RoleCode");
            return View();
        }

        // POST: Employee/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("EmployeeID,Name,Gender,Birthday,Address,Phone,PersonalID,HireDate,JobTitle,Experience,EmployeePhoto,RoleCode,Password,DueDate")] Employee employee)
        {
            if (ModelState.IsValid)
            {
                _context.Add(employee);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["RoleCode"] = new SelectList(_context.EmployeeRoles, "RoleCode", "RoleCode", employee.RoleCode);
            return View(employee);
        }

        // GET: Employee/Edit/5
        public async Task<IActionResult> Edit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var employee = await _context.Employee.FindAsync(id);
            if (employee == null)
            {
                return NotFound();
            }
            ViewData["RoleCode"] = new SelectList(_context.EmployeeRoles, "RoleCode", "RoleCode", employee.RoleCode);
            return View(employee);
        }

        // POST: Employee/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, [Bind("EmployeeID,Name,Gender,Birthday,Address,Phone,PersonalID,HireDate,JobTitle,Experience,EmployeePhoto,RoleCode,Password,DueDate")] Employee employee)
        {
            if (id != employee.EmployeeID)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(employee);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!EmployeeExists(employee.EmployeeID))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            ViewData["RoleCode"] = new SelectList(_context.EmployeeRoles, "RoleCode", "RoleCode", employee.RoleCode);
            return View(employee);
        }

        // GET: Employee/Delete/5
        public async Task<IActionResult> Delete(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var employee = await _context.Employee
                .Include(e => e.RoleCodeNavigation)
                .FirstOrDefaultAsync(m => m.EmployeeID == id);
            if (employee == null)
            {
                return NotFound();
            }

            return View(employee);
        }

        // POST: Employee/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            var employee = await _context.Employee.FindAsync(id);
            if (employee != null)
            {
                _context.Employee.Remove(employee);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool EmployeeExists(string id)
        {
            return _context.Employee.Any(e => e.EmployeeID == id);
        }
    }
}
