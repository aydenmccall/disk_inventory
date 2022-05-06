using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using DiskInventory.Models;

namespace DiskInventory.Controllers
{
    public class BorrowerController : Controller
    {
        private disk_inventoryamContext context;
        public BorrowerController(disk_inventoryamContext ctx) => context = ctx;
        public IActionResult Index(string message = "", string textClass = "text-success")
        {
            ViewBag.Message = message;
            ViewBag.TextClass = textClass;
            List<Borrower> borrowers = context.Borrowers.OrderBy(b => b.LastName).ThenBy(b => b.FirstName).ToList();
            return View(borrowers);
        }
        [HttpGet]
        public IActionResult Add()
        {
            ViewBag.action = "Add";
            return View("Edit", new Borrower());
        }
        [HttpGet]
        public IActionResult Edit(int id)
        {
            ViewBag.action = "Edit";
            Borrower borrower = context.Borrowers.Find(id) ?? new Borrower();           
            return View(borrower);
        }
        [HttpPost]
        public IActionResult Edit(Borrower borrower)
        {
            if(ModelState.IsValid)
            {

                if (borrower.BorrowerId == 0)
                {
                    //context.Add(borrower);
                    context.Database.ExecuteSqlRaw("execute sp_ins_borrower @p0, @p1, @p2",
                        parameters: new[] { borrower.FirstName.ToString(), borrower.LastName.ToString(), borrower.PhoneNum.ToString() });
                    context.SaveChanges();
                    return RedirectToAction("Index", "Borrower", new { message = "Borrower Successfully Added"});
                }
                else
                {
                    //context.Update(borrower);
                    context.Database.ExecuteSqlRaw("execute sp_upd_borrower @p0, @p1, @p2, @p3",
                        parameters: new[] { borrower.BorrowerId.ToString(), borrower.FirstName.ToString(), borrower.LastName.ToString(), borrower.PhoneNum.ToString() });
                    context.SaveChanges();
                    return RedirectToAction("Index", "Borrower", new { message = "Borrower Successfully Edited" });
                }
            }
            else
            {
                ViewBag.Action = (borrower.BorrowerId == 0) ? "Add" : "Edit";
                return View(borrower);
            }
            
        }
        [HttpGet]
        public IActionResult Delete(int id)
        {
            Borrower borrower = context.Borrowers.Find(id); 
            return View(borrower);
        }
        [HttpPost]
        public IActionResult Delete(Borrower borrower)
        {
            try
            {
                context.Database.ExecuteSqlRaw("execute sp_del_borrower @p0",
                parameters: borrower.BorrowerId.ToString());
                context.SaveChanges();
            }
            catch(Exception e)
            {
                return RedirectToAction("Index", "Borrower", new { message = "Borrow Log Records related to borrower conflict with deletion. Please remove associated records first.", textClass = "text-danger" });
            }
                
            
            return RedirectToAction("Index", "Borrower", new { message = "Borrower Successfully Removed " });
        }
    }
}
