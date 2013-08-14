require 'spec_helper'

describe TceExport::MG::MonthlyMonitoring::DirectPurchaseGenerator do
  let :budget_structure_parent do
    BudgetStructure.new(
      id: 2,
      code: '1',
      tce_code: '051',
      description: 'Secretaria de Educação',
      acronym: 'SEMUEDU',
      performance_field: 'Desenvolvimento Educacional')
  end

  let :budget_structure do
    BudgetStructure.new(
      id: 1,
      parent_id: 2,
      code: '29',
      tce_code: '051',
      description: 'Secretaria de Desenvolvimento',
      acronym: 'SEMUEDU',
      performance_field: 'Desenvolvimento Educacional')
  end

  describe "#generate_file" do
    before do
      FileUtils.rm_f('tmp/DISPENSA.csv')
    end

    after do
      FileUtils.rm_f('tmp/DISPENSA.csv')
    end

    let(:emissao_edital) { StageProcess.make!(:emissao_edital, description: "Cotação de preços", type_of_purchase: PurchaseProcessTypeOfPurchase::DIRECT_PURCHASE) }
    let(:sobrinho) { Employee.make!(:sobrinho) }

    let :expense_nature do
      ExpenseNature.new(id: 1, expense_nature: '3.1.90.01.01')
    end

    it "generates a CSV file with the required data" do
      BudgetStructure.should_receive(:find).at_least(1).times.with(2, params: {}).and_return(budget_structure_parent)
      BudgetStructure.should_receive(:find).at_least(1).times.with(1, params: {}).and_return(budget_structure)

      prefecture = Prefecture.make!(:belo_horizonte)
      FactoryGirl.create(:extended_prefecture, prefecture: prefecture)

      monthly_monitoring = FactoryGirl.create(:monthly_monitoring,
        prefecture: prefecture,
        month: 5,
        year: 2013)

      ExpenseNature.stub(:find).and_return(expense_nature)

      budget_allocation = BudgetAllocation.new(
        id: 1,
        code: 1,
        budget_allocation_capabilities: [
          { amount: 500.00,
            budget_allocation: {
              budget_structure: budget_structure, function_code: "04", subfunction_code: "01",
              government_program_code: "003", government_action_code: "003",
              expense_nature_expense_nature: expense_nature.expense_nature, amount: 500.8 },
            capability: { capability_source_code: "001"}
          }
        ]
      )

      BudgetAllocation.stub(:find).and_return(budget_allocation)

      purchase_process_budget_allocation = PurchaseProcessBudgetAllocation.make!(:alocacao_com_itens,
        budget_allocation_id: budget_allocation.id)

      creditor = Creditor.make!(:wenderson_sa)
      item = PurchaseProcessItem.make!(:item, creditor: creditor)

      licitation = LicitationProcess.make!(:compra_direta,
        purchase_process_budget_allocations: [purchase_process_budget_allocation],
        items: [item],
        authorization_envelope_opening_date: Date.new(2013, 5, 20))

      ProcessResponsible.create!(licitation_process_id: licitation.id,
                                 stage_process_id: emissao_edital.id,
                                 employee_id: sobrinho.id)

      publication = LicitationProcessPublication.make!(:publicacao,
        publication_of: PublicationOf::CONFIRMATION,
        licitation_process: licitation)

      ratification = LicitationProcessRatification.make!(:processo_licitatorio_computador,
        licitation_process: licitation,
        creditor: creditor,
        ratification_date: Date.new(2013, 5, 23))

      described_class.generate_file(monthly_monitoring)

      csv = File.read('tmp/DISPENSA.csv', encoding: 'ISO-8859-1')

      expect(csv).to eq "10;98;98029;2013;2;1;20032013;2;Licitação para compra de carteiras;Justificativa legal;Justificativa;20042012;Publicacao\n" +
                        "11;98;98029;2013;2;1;2;00315198737;Gabriel Sobrinho;Girassol;São Francisco;1;PR;33400500;3333333333;gabriel.sobrinho@gmail.com\n" +
                        "12;98;98029;2013;2;1;2050;#{item.item_number};Antivirus;10,0000\n" +
                        "13;98;98029;2013;2;1;98;98029;04;01;003;003; ;319001;001;50080\n" +
                        "14;98;98029;2013;2;1;1;00314951334;Wenderson Malheiros; ; ; ; ; ; ; ; ; ; ; ;2050;#{item.item_number};2,0000;10,0000"
    end

    it 'should not generate data when removal_by_limit' do
      prefecture = Prefecture.make!(:belo_horizonte)
      FactoryGirl.create(:extended_prefecture, prefecture: prefecture)

      monthly_monitoring = FactoryGirl.create(:monthly_monitoring,
        prefecture: prefecture,
        month: 5,
        year: 2013)

      budget_allocation = BudgetAllocation.new(
        id: 1,
        budget_allocation_capabilities: [{amount: 500, budget_allocation_id: 1, capability: "123"}]
      )

      BudgetAllocation.stub(:find).and_return(budget_allocation)

      purchase_process_budget_allocation = PurchaseProcessBudgetAllocation.make(:alocacao_com_itens,
        budget_allocation_id: budget_allocation.id)

      creditor = Creditor.make!(:wenderson_sa)
      item = PurchaseProcessItem.make!(:item, creditor: creditor)

      licitation = LicitationProcess.make!(:compra_direta,
        purchase_process_budget_allocations: [purchase_process_budget_allocation],
        items: [item],
        type_of_removal: TypeOfRemoval::REMOVAL_BY_LIMIT,
        authorization_envelope_opening_date: Date.new(2013, 5, 20))

      ProcessResponsible.create!(licitation_process_id: licitation.id,
                                 stage_process_id: emissao_edital.id,
                                 employee_id: sobrinho.id)

      publication = LicitationProcessPublication.make!(:publicacao,
        publication_of: PublicationOf::CONFIRMATION,
        licitation_process: licitation)

      ratification = LicitationProcessRatification.make!(:processo_licitatorio_computador,
        licitation_process: licitation,
        creditor: creditor,
        ratification_date: Date.new(2013, 5, 23))

      described_class.generate_file(monthly_monitoring)

      csv = File.read('tmp/DISPENSA.csv', encoding: 'ISO-8859-1')

      expect(csv).to eq ""
    end
  end
end
