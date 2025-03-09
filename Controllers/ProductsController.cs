using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using iStudyTest.Models;
using System.ComponentModel.Design;

namespace iStudyTest.Controllers
{
    public class ProductsController : Controller
    {
        private readonly iStudyTestContext _context;

        public ProductsController(iStudyTestContext context)
        {
            _context = context;
        }

        // GET: Products
        public async Task<IActionResult> Index(string? CompanyID)
        {
            var products = _context.Product.OrderBy(p => p.CompanyID).Include(p => p.Company).AsQueryable();
            if (!string.IsNullOrEmpty(CompanyID))
            {
                products = products.Where(p => p.CompanyID == CompanyID);
            }
            ViewData["Company"] = await _context.InsuranceCompany.ToListAsync();
            return View(await products.ToListAsync());
        }

        // GET: Products/Details/5
        public async Task<IActionResult> Details(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var product = await _context.Product
                .Include(p => p.Company)
                .FirstOrDefaultAsync(m => m.ProductNumber == id);
            if (product == null)
            {
                return NotFound();
            }

            return View(product);
        }

        // GET: Products/Create
        public IActionResult Create()
        {
            ViewData["CompanyID"] = new SelectList(_context.InsuranceCompany, "CompanyID", "CompanyID");
            return View();
        }

        // POST: Products/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("ProductNumber,ProductName,LaunchDate,DiscontinuedDate,ValidityPeriod,Type,CompanyID,DM,DMType,Feature")] Product product)
        {
            if (ModelState.IsValid)
            {
                _context.Add(product);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["CompanyID"] = new SelectList(_context.InsuranceCompany, "CompanyID", "CompanyID", product.CompanyID);
            return View(product);
        }

        // GET: Products/Edit/5
        public async Task<IActionResult> Edit(string id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var product = await _context.Product.FindAsync(id);
            if (product == null)
            {
                return NotFound();
            }
            ViewData["CompanyID"] = new SelectList(_context.InsuranceCompany, "CompanyID", "CompanyID", product.CompanyID);
            return View(product);
        }

        // POST: Products/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, [Bind("ProductNumber,ProductName,LaunchDate,DiscontinuedDate,ValidityPeriod,Type,CompanyID,DM,DMType,Feature")] Product product)
        {
            if (id != product.ProductNumber)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(product);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ProductExists(product.ProductNumber))
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
            ViewData["CompanyID"] = new SelectList(_context.InsuranceCompany, "CompanyID", "CompanyID", product.CompanyID);
            return View(product);
        }

        private bool ProductExists(string id)
        {
            return _context.Product.Any(e => e.ProductNumber == id);
        }
    }
}
