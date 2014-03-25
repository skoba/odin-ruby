describe OpenEHR::Parser::ODINParslet do
  let(:parslet) { OpenEHR::Parser::ODINParslet.new }

  it 'should not raise error' do
    expect { parslet }.not_to raise_error
  end

  context 'ODIN parslet makes abstract syntax tree' do
    let(:filestream) { File.open(EXAMPLES+'/adl_workbench.cfg', 'r:bom|utf-8')}
    let(:ast) { begin parslet.parse(filestream.read); rescue Parslet::ParseFailed => error; puts error.cause.ascii_tree; end}

    it 'should not raise error' do
      expect { ast }.not_to raise_error
    end

    after { filestream.close }
  end
end
