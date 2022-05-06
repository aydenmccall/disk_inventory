using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using DiskInventory.Models;
using Microsoft.EntityFrameworkCore;

namespace DiskInventory.Controllers
{
    public class BorrowLogController : Controller
    {
        private disk_inventoryamContext context;
        public BorrowLogController(disk_inventoryamContext ctx) => context = ctx;

        private BorrowLogViewModel CreateViewModel(DiskBorrowLog log = null)
        {
            BorrowLogViewModel logViewModel = new BorrowLogViewModel();
            logViewModel.Disks = context.Disks.OrderBy(d => d.DiskName).ToList();
            logViewModel.Borrowers = context.Borrowers.OrderBy(b => b.LastName).ToList();
            if (log != null)
                logViewModel.Log = log;
            return logViewModel;
        }
        //private DiskBorrowLog ConvertFromViewToLog(BorrowLogViewModel logViewModel)
        //{
        //    DiskBorrowLog log = new DiskBorrowLog();
        //    log = logViewModel.Log;
        //    return log;
        //}
        //private BorrowLogViewModel ConvertFromLogToView(DiskBorrowLog log)
        //{
        //    BorrowLogViewModel logViewModel = CreateViewModel();
        //    logViewModel.Log = log;
        //    return logViewModel;
        //}
        public IActionResult Index(string message = "")
        {
            ViewBag.message = message;
            List<DiskBorrowLog> borrowLogs = context.DiskBorrowLogs.Include(l => l.Disk).Include(l => l.Borrower).OrderBy(l => l.Disk.DiskName)
                .ThenBy(l => l.Borrower.LastName).ToList();
            return View(borrowLogs);
        }
        [HttpGet]
        public IActionResult Edit(int id)
        {
            ViewBag.Action = "Edit";
            DiskBorrowLog log = context.DiskBorrowLogs.Find(id);
            BorrowLogViewModel viewModel = CreateViewModel(log);
            return View(viewModel);
        }
        [HttpPost]
        public IActionResult Edit(BorrowLogViewModel logViewModel)
        {
            //DiskBorrowLog log = ConvertFromViewToLog(logViewModel);
            ViewBag.Action = "Edit";
            if (ModelState.IsValid)
            {
                //context.DiskBorrowLogs.Update(logViewModel.Log);
                context.Database.ExecuteSqlRaw("execute sp_upd_diskBorrowLog @p0, @p1, @p2, @p3, @p4", 
                    parameters: new[] { logViewModel.Log.DiskLogId.ToString(), logViewModel.Log.DiskId.ToString(), logViewModel.Log.BorrowerId.ToString(), 
                    logViewModel.Log.BorrowedDate?.ToShortDateString(), logViewModel.Log.ReturnedDate?.ToShortDateString()});

                context.SaveChanges();
                return RedirectToAction("Index", new { message = "Log Edited Successfully." });
            }
            return View(logViewModel);
               
        }
        [HttpGet]
        public IActionResult Add()
        {
            ViewBag.Action = "Add";
            return View("Edit", CreateViewModel());
        }

        [HttpPost]
        public IActionResult Add(BorrowLogViewModel logViewModel)
        {
            ViewBag.Action = "Add";
            if(ModelState.IsValid)
            {
                //context.DiskBorrowLogs.Add(logViewModel.Log);
                context.Database.ExecuteSqlRaw("execute sp_ins_diskBorrowLog @p0, @p1, @p2, @p3",
                    parameters: new[] { logViewModel.Log.DiskId.ToString(), logViewModel.Log.BorrowerId.ToString(),
                    logViewModel.Log.BorrowedDate?.ToShortDateString(), logViewModel.Log.ReturnedDate?.ToShortDateString()});
                context.SaveChanges();
                return RedirectToAction("Index", new { message = "Log Added Successfully." });
            }
            return View("Edit", CreateViewModel());
        }
    }
}
