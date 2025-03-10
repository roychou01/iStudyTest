using iStudyTest.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Http;
using System.Reflection.Metadata;
using NuGet.Protocol;

namespace iStudyTest.Controllers
{
    public class LoginController : Controller
    {
        private readonly iStudyTestContext _context;
        public LoginController(iStudyTestContext context)
        {
            _context = context;
        }

        public IActionResult Login()
        {
            return View();
        }

        [HttpPost]

        public async Task<IActionResult> Login(Member member)
        {
            var result = await _context.Member.Where(m => m.Email == member.Email && m.Password == _context.ComputeSha256Hash(member.Password)).FirstOrDefaultAsync();

            //如果帳密正確,導入後台頁面
            if (result != null)
            {
                //發給證明,證明他已經登入
                HttpContext.Session.SetString("MemberInfo", result.ToJson());

                return RedirectToAction("Index", "ProductList");
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
            HttpContext.Session.Remove("Member");//清掉Manager的Session
            return RedirectToAction("Index", "Home");
        }

    }
}
