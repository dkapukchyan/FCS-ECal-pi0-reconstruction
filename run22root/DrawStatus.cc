/*
  Author: David Kapukchyan

  @[November 30, 2022]>First instance

  The purpose of this macro is to easily draw the status plots after running *draw_all_towermassfit2.C*
*/

void DrawStatus(const char* day, const char* iteration)
{
  TString Day(day);
  TString nfile_name(iteration);
  TString sfile_name(iteration);
  nfile_name = "statusN_iteration"+nfile_name+".root";
  sfile_name = "statusS_iteration"+sfile_name+".root";
  TFile* NFile = TFile::Open(nfile_name.Data());
  TFile* SFile = TFile::Open(sfile_name.Data());

  if( NFile==0 || NFile->IsZombie() ){ std::cout << "Unable to open: "<<nfile_name << std::endl; return; }
  if( SFile==0 || SFile->IsZombie() ){ std::cout << "Unable to open: "<<sfile_name << std::endl; return; }

  TH2F* statusN = NFile->Get("statusN");
  TH2F* statusS = SFile->Get("statusS");

  TCanvas* c1 = new TCanvas("c1","Status Plots",1920,1080);
  c1->Divide(2,1);
  c1->cd(1);
  statusS->Draw("colz");//Draw first since South is negative columns
  c1->cd(2);
  statusN->Draw("colz");
  TString savename(iteration);
  savename = "Status_"+Day+"_iteration"+savename+".png";
  c1->SaveAs(savename.Data());
  c1->Clear();
  NFile->Close();
  SFile->Close();

  TString anafile_name(iteration);
  anafile_name = "StFcsPi0invariantmass"+Day+"testAll_iteration"+anafile_name+".root";
  TFile* AnaFile = TFile::Open(anafile_name.Data());
  if( AnaFile==0 || AnaFile->IsZombie() ){ std::cout << "Unable to open: "<<anafile_name << std::endl; return; }

  TH1F* inv_mass_cluster = AnaFile->Get("h1_inv_mass_cluster");
  c1->cd();
  inv_mass_cluster->Draw("hist e");
  TLine* pi0line = new TLine(0.135,0,0.135, 1.05*inv_mass_cluster->GetBinContent(inv_mass_cluster->GetMaximumBin()) );
  pi0line->SetLineColor(kRed);
  pi0line->Draw("same");
  TString savename2(iteration);
  savename2 = "inv_mass_cluster_" + Day + "_iteration" + savename2 + ".png";
  c1->SaveAs(savename2.Data());
  c1->Clear();

  AnaFile->Close();
  
  delete c1;

}
