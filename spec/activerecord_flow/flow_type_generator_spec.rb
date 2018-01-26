require 'spec_helper'
require 'activerecord_flow/flow_type_generator'

RSpec.describe ActiverecordFlow::FlowTypeGenerator do
  describe '#convert' do
    context 'not an activerecord object' do
      it 'raises error' do
        flow_type_gen = ActiverecordFlow::FlowTypeGenerator.new(Model)

        expect { flow_type_gen.convert }.to raise_error(
          'Not an ActiveRecord object'
        )
      end
    end

    context 'when it is an activerecord object' do
      it 'returns the flowtype definition' do
        flow_type_gen = ActiverecordFlow::FlowTypeGenerator.new(User)

        expect(flow_type_gen.convert).to eq(
          'id' => '?number',
          'username' => '?string',
          'password' => '?string',
          'created_at' => 'Date',
          'updated_at' => 'Date'
        )
      end

      context 'primary key is always optional' do
        it 'returns the flowtype definition' do
          flow_type_gen = ActiverecordFlow::FlowTypeGenerator.new(Video)

          expect(flow_type_gen.convert).to include(
            'uuid' => '?number',
            'title' => '?string'
          )
        end
      end

      context 'when it has nested associations' do
        context 'when it has a has_many association' do
          it 'returns the flowtype definition' do
            flow_type_gen = ActiverecordFlow::FlowTypeGenerator.new(Post)

            expect(flow_type_gen.convert).to eq(
              'id' => '?number',
              'content' => '?string',
              'user_id' => 'number',
              'user' => 'User',
              'comments' => 'Array<Comment>',
              'images' => 'Array<Image>',
              'created_at' => 'Date',
              'updated_at' => 'Date'
            )
          end

          context 'when it has a different class_name' do
            it 'returns the flowtype definition' do
              flow_type_gen = ActiverecordFlow::FlowTypeGenerator.new(Blog)

              expect(flow_type_gen.convert).to include(
                'entries' => 'Array<Post>'
              )
            end
          end

          context 'when it has many through' do
            it 'returns the flowtype definition' do
              flow_type_gen = ActiverecordFlow::FlowTypeGenerator.new(Blog)

              expect(flow_type_gen.convert).to include(
                'comments' => 'Array<Comment>'
              )
            end
          end
        end

        context 'when it has a has_one association' do
          it 'returns the flowtype definition' do
            flow_type_gen = ActiverecordFlow::FlowTypeGenerator.new(Image)

            expect(flow_type_gen.convert).to include(
              'id' => '?number',
              'url' => 'Url',
              'created_at' => 'Date',
              'updated_at' => 'Date'
            )
          end

          context 'when it has one through' do
            it 'returns the flowtype definition' do
              flow_type_gen = ActiverecordFlow::FlowTypeGenerator.new(Video)

              expect(flow_type_gen.convert).to include(
                'thumb_url' => 'Url'
              )
            end
          end
        end

        context 'when it has a belongs_to association' do
          it 'returns the flowtype definition' do
            flow_type_gen = ActiverecordFlow::FlowTypeGenerator.new(Comment)

            expect(flow_type_gen.convert).to eq(
              'id' => '?number',
              'content' => '?string',
              'post_id' => 'number',
              'user_id' => '?number',
              'post' => 'Post',
              'user' => 'User',
              'created_at' => 'Date',
              'updated_at' => 'Date'
            )
          end

          context 'when it is a polymorphic relation' do
            it 'returns the flowtype definition' do
              flow_type_gen = ActiverecordFlow::FlowTypeGenerator.new(Image)

              expect(flow_type_gen.convert).to include(
                'content_type' => '?string',
                'content_id' => '?number',
                'content' => 'Post | Blog'
              )
            end
          end
        end
      end
    end
  end

  describe '#render' do
  end
end
