using iStudyTest.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Http;
using System.Reflection.Metadata;

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
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login(MemberLogin login)
        {
            string sql = "select * from MemberLogin where Email = @Email and Password = @Password";
            SqlParameter[] parameters =
            {
                new SqlParameter("@Email", login.Email),
                new SqlParameter("@Password",login.Password)
            };

            var result = await _context.MemberLogin.FromSqlRaw(sql, parameters).FirstOrDefaultAsync();

            if (result != null)
            {
                HttpContext.Session.SetString("Member", result.Email);
                return RedirectToAction("Index", "Products");
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
