using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using iStudyTest.Models;
using AspNetCoreGeneratedDocument;
using System.Runtime.InteropServices;

namespace iStudyTest.Controllers
{
    public class ProductsPreviewController : Controller
    {
        private readonly iStudyTestContext _context;

        public ProductsPreviewController(iStudyTestContext context)
        {
            _context = context;
        }

        // GET: ProductsPreview
        public async Task<IActionResult> Index(string? companyID)
        {
            var products = _context.Product.OrderBy(p => p.ProductName).Include(p => p.Company).AsQueryable();
            if (!string.IsNullOrEmpty(companyID))
            {
                products = products.Where(p => p.CompanyID == companyID);
            }
            ViewData["Company"] = await _context.InsuranceCompany.ToListAsync();
            return View(await products.ToListAsync());
        }

        // GET: ProductsPreview/Details/5
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

        // GET: ProductsPreview/Details/5
        public async Task<IActionResult> ModalDetails(string id)
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

        private bool ProductExists(string id)
        {
            return _context.Product.Any(e => e.ProductNumber == id);
        }
    }
}
